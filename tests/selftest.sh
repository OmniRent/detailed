#!/usr/bin/env bash
# Self-check for the "detailed" skill: run with `bash tests/selftest.sh` from the repo root.
#   1. The skill directory contains no project-specific words (the process must stay generic).
#   2. The reminder hook reads everything from the config and reports the right rows.
set -u

REPO="$(cd "$(dirname "$0")/.." && pwd)"
HOOK="$REPO/skills/detailed/scripts/reminders.sh"
FAILED=0
ok()   { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; FAILED=1; }
has()  { case "$2" in *"$1"*) ok "$3" ;; *) fail "$3 (missing: $1)"; printf '%s\n' "$2" | sed 's/^/       | /' ;; esac; }
lacks() { case "$2" in *"$1"*) fail "$3 (unexpected: $1)" ;; *) ok "$3" ;; esac; }

# --- 1. Generic check ---------------------------------------------------------------------------
# Words that belong to a project, never to the standard. Extend the list in tests/project-words.txt.
WORDS="$(grep -v '^#' "$REPO/tests/project-words.txt" | grep -v '^$' | paste -sd'|' -)"
hits="$(grep -rniwE "$WORDS" "$REPO/skills/detailed" || true)"
if [ -z "$hits" ]; then ok "skill directory has no project words"; else fail "project words in the skill directory"; printf '%s\n' "$hits" | sed 's/^/       | /'; fi

# --- 1b. Skill structure: name matches the directory, every referenced file exists --------------
SKILL_DIR="$REPO/skills/detailed"
name="$(awk -F': *' '/^name:/{print $2; exit}' "$SKILL_DIR/SKILL.md")"
[ "$name" = "$(basename "$SKILL_DIR")" ] && ok "skill name matches its directory" || fail "skill name '$name' does not match the directory"
missing=""
for ref in $(grep -rhoE '`(references|templates|scripts)/[A-Za-z0-9._/-]+`' "$SKILL_DIR" | tr -d '`' | sort -u); do
  [ -e "$SKILL_DIR/$ref" ] || missing="$missing $ref"
done
[ -z "$missing" ] && ok "every file referenced in the skill exists" || fail "referenced files missing:$missing"
# Config keys named in the skill text: every snake_case token in backticks, plus the one-word keys.
for key in $(grep -rhoE '`([a-z]+(_[a-z]+)+|register|people|state|design)`' "$SKILL_DIR" --include='*.md' | tr -d '`' | sort -u); do
  grep -q "^$key=" "$SKILL_DIR/templates/detailed.conf" || missing="$missing $key"
done
[ -z "$missing" ] && ok "every config key named in the skill is in the config template" || fail "config keys missing from the template:$missing"

# --- 1c. No magic numbers: limits live in the config, not in the skill text or the hook ---------------
# A number next to a unit of time, count or length is a limit; it belongs in templates/detailed.conf.
# Example rows (dated 20xx-) in the references are fictional and skipped.
hits="$(grep -rnE '[0-9]+ ?(minut|min|dni|dzień|dnia|godzin|zadań|cykl|cykli|cykle|linii|liniach|słów|wierszy)([^a-ząćęłńóśźż]|$)' "$SKILL_DIR" --include='*.md' | grep -vE '\| 20[0-9]{2}-[0-9]{2}-[0-9]{2} \|' || true)"
if [ -z "$hits" ]; then ok "skill text has no hard-coded limits"; else fail "hard-coded limits in the skill text"; printf '%s\n' "$hits" | sed 's/^/       | /'; fi
hits="$(grep -nE '^[A-Z_]+=([2-9]|[0-9]{2,})' "$HOOK" || true)"  # 0/1 are flags, not settings
if [ -z "$hits" ]; then ok "hook has no hard-coded settings"; else fail "hard-coded settings in the hook"; printf '%s\n' "$hits" | sed 's/^/       | /'; fi

# --- 2. Hook behaviour on a throwaway repo ------------------------------------------------------------
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null
git init -q --bare "$TMP/remote.git"
git clone -q "$TMP/remote.git" "$TMP/work" 2>/dev/null
cd "$TMP/work" || exit 1
git checkout -q -b trunk
mkdir -p .claude notes

cat > .claude/detailed.conf <<'EOF'
# test config: non-default names on purpose
project=Sample
people=.claude/people.tsv
gate_role=lead
external_parties=Client, Client lawyer
external_overdue_days=7
default_branch=trunk
register=notes/register.md
knowledge_dirs=notes
col_id=Key
col_subject=Topic,Check
col_waiting=Waiting on
col_since=Since
col_status=State
status_closed_prefix=closed
reminder_subject_words=3
reminder_summary_lines=2
EOF
printf 'person\trole\temails\tname_pattern\nLena\tlead\tlena@example.com\t-\nDan\tdev\tdan@example.com,dan.alt@example.com\t-\n' > .claude/people.tsv
cat > notes/register.md <<'EOF'
# Register

| Column | Meaning |
|---|---|
| Key | identifier |

| Key | Topic | Waiting on | Since | State |
|---|---|---|---|---|
| A-01 | first open matter for the developer | Dan | 2020-01-01 | open |
| A-02 | question the client has not answered | Client | 2020-01-02 | open |
| A-03 | matter of the lead that the developer will close | Lena | 2020-01-03 | open |
| A-04 | another open matter of the lead | Lena | 2020-01-04 | open |
| A-05 | fresh question to the client lawyer | Client lawyer | 2999-01-01 | open |

| Key | Check | Waiting on | Since | State |
|---|---|---|---|---|
| T-01 | a test in a second table with another subject column | Dan | 2020-01-05 | open |
EOF
git add -A
git -c user.name=Lena -c user.email=lena@example.com commit -q -m "register"
sed 's/| A-03 \(.*\)| open |/| A-03 \1| closed 01.01 (Lena) |/' notes/register.md > notes/register.tmp && mv notes/register.tmp notes/register.md
git -c user.name=Dan -c user.email=dan.alt@example.com commit -q -am "close A-03 without the lead"
git push -q origin trunk

run() { CLAUDE_PROJECT_DIR="$TMP/work" bash "$HOOK" "$1" </dev/null; }

git config user.email dan.alt@example.com; git config user.name whoever
out="$(run start)"
has "osoba: Dan" "$out" "person recognised by a secondary e-mail"
has "Czeka na Ciebie (Dan): 2" "$out" "rows waiting on the person, from both tables"
has "A-01" "$out" "row from the first table listed"
has "T-01" "$out" "row from the table with the alternative subject column listed"
has "(lead: Lena): 1 spraw" "$out" "open rows waiting on the gate role counted"
has "A-03 —" "$out" "gate flags a row closed by someone outside the gate role"
lacks "Strony zewnętrzne" "$out" "overdue external parties hidden from a non-gate person"
has "[Przypomnienia z rejestru projektu Sample (notes/register.md)" "$out" "header built from the config"
has "A-01 · first open matter …" "$out" "subject cut after reminder_subject_words words"
has "w 2 liniach" "$out" "summary length taken from reminder_summary_lines"

out="$(run prompt)"
[ -z "$out" ] && ok "prompt mode is silent within the interval" || fail "prompt mode spoke within the interval"

git config user.email lena@example.com
out="$(run start)"
has "bez odpowiedzi od ponad 7 dni: 1" "$out" "overdue external party shown to the gate role"
has "A-02" "$out" "overdue row listed"
lacks "A-05" "$out" "row newer than the threshold not listed as overdue"
has "Czeka na Ciebie (Lena): 1" "$out" "closed row not counted as waiting"

git config user.email stranger@example.com
out="$(run start)"
has "Nie rozpoznano osoby" "$out" "unknown person: ask who runs the session"
has "Lena, Dan" "$out" "question lists the people from the people file"

echo "note" > notes/new.md
out="$(DETAILED_PERSON=Dan run start)"
has "Niezapisane w gicie zmiany w notes: 1" "$out" "unsaved knowledge reported"

rm .claude/detailed.conf
out="$(run start)"
[ -z "$out" ] && ok "no config: silent" || fail "no config: hook printed something"

[ "$FAILED" -eq 0 ] && echo "ALL OK" || echo "SELFTEST FAILED"
exit "$FAILED"
