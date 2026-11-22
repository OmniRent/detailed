#!/usr/bin/env bash
# Register reminders for Claude Code sessions (part of the "detailed" skill).
#
# Usage (from .claude/settings.json of a project, or from user settings):
#   reminders.sh start    SessionStart: fetch the default branch, always print reminders
#   reminders.sh prompt   UserPromptSubmit: print at most once per interval,
#                         or at once when someone else changed the register upstream
#
# Every project fact comes from <repo>/.claude/detailed.conf and the people file it names
# (templates/detailed.conf, templates/osoby.tsv). A repo without that config gets no output.
# The script never blocks work: it always exits 0.
# Works with bash 3.2 / BSD awk (macOS) and Linux. State lives in .git/detailed-reminders/.
#
# ponytail: messages are in Polish only; add a message catalogue when a non-Polish team adopts this.

set -u

MODE="${1:-prompt}"

# Hooks receive JSON on stdin; drain it so the pipe is closed.
[ -t 0 ] || cat >/dev/null 2>&1

ROOT="${CLAUDE_PROJECT_DIR:-}"
[ -n "$ROOT" ] || ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -n "$ROOT" ] && cd "$ROOT" 2>/dev/null || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

CONF="${DETAILED_CONF:-.claude/detailed.conf}"
[ -f "$CONF" ] || exit 0

# conf KEY DEFAULT: value of "KEY=value" from the config (parsed, never sourced).
conf() {
  local v
  v="$(awk -v k="$1" '
    /^[ \t]*#/ || !/=/ { next }
    {
      key = $0; sub(/=.*/, "", key); gsub(/^[ \t]+|[ \t]+$/, "", key)
      if (key == k) { val = $0; sub(/^[^=]*=/, "", val); gsub(/^[ \t]+|[ \t]+$/, "", val); print val; exit }
    }' "$CONF" 2>/dev/null)"
  if [ -n "$v" ]; then printf '%s' "$v"; else printf '%s' "$2"; fi
}
# int VALUE DEFAULT: VALUE if it is a non-negative integer, DEFAULT otherwise.
int() { case "$1" in ''|*[!0-9]*) printf '%s' "$2" ;; *) printf '%s' "$1" ;; esac; }

REG="$(conf register "")"
[ -n "$REG" ] || exit 0
PROJECT="$(conf project "$(basename "$ROOT")")"
PEOPLE="$(conf people ".claude/osoby.tsv")"
REMOTE="$(conf remote origin)"
BRANCH="$(conf default_branch main)"
GATE_ROLE="$(conf gate_role pm)"
EXTERNAL="$(conf external_parties "")"
OVERDUE_DAYS="$(int "$(conf external_overdue_days 7)" 7)"
INTERVAL_MIN="$(int "${DETAILED_INTERVAL_MIN:-$(conf reminder_interval_min 60)}" 60)"
FETCH_MIN="$(int "$(conf fetch_interval_min 10)" 10)"          # background fetch at most this often in "prompt" mode
MAX_ROWS="$(int "$(conf reminder_max_rows 8)" 8)"              # rows shown per list
SUBJECT_WORDS="$(int "$(conf reminder_subject_words 14)" 14)"  # words of the subject shown per row
SUMMARY_LINES="$(conf reminder_summary_lines 1-3)"            # how many lines the session gives the reminders
KNOWLEDGE_DIRS="$(conf knowledge_dirs docs | sed 's/[ ]*,[ ]*/,/g')"
C_ID="$(conf col_id ID)"
C_SUBJECT="$(conf col_subject Sprawa)"
C_WAITING="$(conf col_waiting "Czeka na")"
C_SINCE="$(conf col_since Od)"
C_STATUS="$(conf col_status Status)"
CLOSED="$(conf status_closed_prefix rozstrzygni)"

GITDIR="$(git rev-parse --git-dir)"
STATE="$GITDIR/detailed-reminders"
mkdir -p "$STATE" 2>/dev/null || exit 0
NOW=$(date +%s)
TAB="$(printf '\t')"

# Seconds since marker $1 was written (a huge number when it is missing).
since() { if [ -f "$STATE/$1" ]; then echo $(( NOW - $(int "$(cat "$STATE/$1" 2>/dev/null)" 0) )); else echo 999999999; fi; }

# --- 1. Fetch the default branch: foreground on start, background on prompts ---------------------
if [ "$MODE" = "start" ]; then
  GIT_TERMINAL_PROMPT=0 git fetch --quiet "$REMOTE" "$BRANCH" >/dev/null 2>&1 && echo "$NOW" > "$STATE/last_fetch"
elif [ "$(since last_fetch)" -ge $(( FETCH_MIN * 60 )) ]; then
  echo "$NOW" > "$STATE/last_fetch"
  ( GIT_TERMINAL_PROMPT=0 git fetch --quiet "$REMOTE" "$BRANCH" >/dev/null 2>&1 & ) >/dev/null 2>&1
fi

# --- 2. Register: upstream version, or the working tree when there is no upstream copy -----------
REF=""
UPSTREAM="$REMOTE/$BRANCH"
if git rev-parse --verify -q "$UPSTREAM" >/dev/null 2>&1 && git cat-file -e "$UPSTREAM:$REG" 2>/dev/null; then
  REF="$UPSTREAM"
  REG_TEXT="$(git show "$REF:$REG")"
  REG_BLOB="$(git rev-parse "$REF:$REG")"
  REG_LAST_AUTHOR="$(git log -1 --format=%ae "$REF" -- "$REG" 2>/dev/null | tr 'A-Z' 'a-z')"
elif [ -f "$REG" ]; then
  REG_TEXT="$(cat "$REG")"
  REG_BLOB="$(git hash-object "$REG")"
  REG_LAST_AUTHOR=""
else
  exit 0
fi

# --- 3. Who is working -----------------------------------------------------------------------------
# People file columns (tab-separated, first line is a header):
#   person, role, e-mails (comma-separated), name pattern (regex matched against git user.name, or "-")
EMAIL="$(git config user.email 2>/dev/null | tr 'A-Z' 'a-z')"
NAME="$(git config user.name 2>/dev/null | tr 'A-Z' 'a-z')"
PERSON="${DETAILED_PERSON:-}"
ROLE=""
GATE_PEOPLE=""
GATE_EMAILS=""
ALL_PEOPLE=""
if [ -f "$PEOPLE" ]; then
  if [ -z "$PERSON" ]; then
    # An e-mail match in any row wins over a name-pattern match.
    PERSON="$(awk -F'\t' -v e="$EMAIL" -v n="$NAME" '
      NR > 1 && $1 !~ /^#/ && $1 != "" {
        m = split(tolower($3), em, ",")
        for (i = 1; i <= m; i++) { gsub(/^[ \t]+|[ \t]+$/, "", em[i]); if (e != "" && em[i] == e && by_mail == "") by_mail = $1 }
        if ($4 != "" && $4 != "-" && n != "" && n ~ $4 && by_name == "") by_name = $1
      }
      END { print (by_mail != "" ? by_mail : by_name) }' "$PEOPLE")"
  fi
  ROLE="$(awk -F'\t' -v p="$PERSON" 'NR > 1 && $1 == p { print $2; exit }' "$PEOPLE")"
  GATE_PEOPLE="$(awk -F'\t' -v r="$GATE_ROLE" 'NR > 1 && $1 !~ /^#/ && $2 == r { print $1 }' "$PEOPLE" | paste -sd, -)"
  GATE_EMAILS="$(awk -F'\t' -v r="$GATE_ROLE" '
    NR > 1 && $1 !~ /^#/ && $2 == r {
      m = split(tolower($3), em, ",")
      for (i = 1; i <= m; i++) { gsub(/^[ \t]+|[ \t]+$/, "", em[i]); if (em[i] != "" && em[i] != "-") print em[i] }
    }' "$PEOPLE")"
  ALL_PEOPLE="$(awk -F'\t' 'NR > 1 && $1 !~ /^#/ && $1 != "" { print $1 }' "$PEOPLE" | paste -sd, - | sed 's/,/, /g')"
fi

# Unknown person (for example a cloud session, where git authorship is not a human): Claude must ask.
ASK_PERSON=""
if [ -z "$PERSON" ]; then
  if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then
    ASK_PERSON="Sesja w chmurze, osoba prowadząca nieznana. Zanim zapiszesz cokolwiek w gicie, zapytaj raz, kto prowadzi sesję (${ALL_PEOPLE:-osoby z $PEOPLE}), i pracuj jako ta osoba."
  else
    ASK_PERSON="Nie rozpoznano osoby z git config (${EMAIL:-brak e-maila}). Zapytaj raz, kto prowadzi sesję (${ALL_PEOPLE:-osoby z $PEOPLE})."
  fi
fi

# --- 4. Should "prompt" mode speak at all -----------------------------------------------------------
LAST_BLOB="$(cat "$STATE/last_blob" 2>/dev/null || true)"
CHANGED_BY_OTHER=0
if [ "$REG_BLOB" != "$LAST_BLOB" ] && [ -n "$LAST_BLOB" ]; then
  if [ -z "$REG_LAST_AUTHOR" ] || [ "$REG_LAST_AUTHOR" != "$EMAIL" ]; then CHANGED_BY_OTHER=1; fi
fi
echo "$REG_BLOB" > "$STATE/last_blob"

if [ "$MODE" = "prompt" ] && [ "$CHANGED_BY_OTHER" -eq 0 ] && [ "$(since last_reminder)" -lt $(( INTERVAL_MIN * 60 )) ]; then
  exit 0
fi

# --- 5. Parse the register tables --------------------------------------------------------------------
# Output: line<TAB>ID<TAB>subject (first SUBJECT_WORDS words)<TAB>waiting on<TAB>since<TAB>status
ROWS="$(printf '%s\n' "$REG_TEXT" | awk -F'|' -v words="$SUBJECT_WORDS" -v cid="$C_ID" -v csubj="$C_SUBJECT" -v cwait="$C_WAITING" -v csince="$C_SINCE" -v cstatus="$C_STATUS" '
  function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
  function short(s,   n, w, i, out) {
    n = split(s, w, " "); out = ""
    for (i = 1; i <= n && i <= words; i++) out = out (i > 1 ? " " : "") w[i]
    if (n > words) out = out " …"
    return out
  }
  BEGIN { ns = split(csubj, subj, ","); for (i = 1; i <= ns; i++) subj[i] = trim(subj[i]) }
  /^\|/ {
    if (!intable) {
      intable = 1
      for (k in col) delete col[k]
      for (i = 2; i < NF; i++) col[trim($i)] = i
      next
    }
    if ($0 ~ /^\|[-: |]+\|[ \t]*$/) next
    if (!(cwait in col) || !(cid in col)) next
    sc = 0
    for (i = 1; i <= ns; i++) if (subj[i] in col) { sc = col[subj[i]]; break }
    st = (cstatus in col) ? trim($(col[cstatus])) : ""
    od = (csince in col) ? trim($(col[csince])) : ""
    printf "%d\t%s\t%s\t%s\t%s\t%s\n", NR, trim($(col[cid])), (sc ? short(trim($(sc))) : ""), trim($(col[cwait])), od, st
    next
  }
  { intable = 0 }
')"

CUTOFF="$(date -v-"${OVERDUE_DAYS}"d +%Y-%m-%d 2>/dev/null || date -d "${OVERDUE_DAYS} days ago" +%Y-%m-%d 2>/dev/null)"

# Up to MAX_ROWS rows (same format as ROWS) as bullet points, oldest first.
print_list() {
  printf '%s\n' "$1" | sort -t "$TAB" -k5,5 | awk -F'\t' -v max="$MAX_ROWS" -v reg="$REG" '
    NF >= 6 { n++; if (n <= max) printf "- %s · %s (od %s)\n", $2, $3, ($5 == "" ? "?" : $5) }
    END { if (n > max) printf "- … i %d więcej (%s)\n", n - max, reg }'
}
count_rows() { printf '%s\n' "$1" | awk -F'\t' 'NF >= 6 { n++ } END { print n + 0 }'; }
# Rows from $1 whose "waiting on" value is in the comma-separated list $2.
waiting_on() {
  printf '%s\n' "$1" | awk -F'\t' -v list="$2" '
    BEGIN { m = split(list, a, ","); for (i = 1; i <= m; i++) { gsub(/^[ \t]+|[ \t]+$/, "", a[i]); if (a[i] != "") want[a[i]] = 1 } }
    NF >= 6 && ($4 in want)'
}

OPEN_ROWS="$(printf '%s\n' "$ROWS" | awk -F'\t' -v closed="$CLOSED" 'NF >= 6 && index($6, closed) != 1')"
OUT=""
add() { OUT="${OUT}$1
"; }

if [ -n "$PERSON" ]; then
  MINE="$(waiting_on "$OPEN_ROWS" "$PERSON")"
  n=$(count_rows "$MINE")
  if [ "$n" -gt 0 ]; then add "Czeka na Ciebie ($PERSON): $n"; add "$(print_list "$MINE")"; fi
fi

# External parties that have not answered: shown to the gate role and to unrecognised sessions.
if [ -n "$EXTERNAL" ] && { [ "$ROLE" = "$GATE_ROLE" ] || [ -z "$PERSON" ]; }; then
  LATE="$(waiting_on "$OPEN_ROWS" "$EXTERNAL" | awk -F'\t' -v c="$CUTOFF" '$5 != "" && $5 < c')"
  n=$(count_rows "$LATE")
  if [ "$n" -gt 0 ]; then add "Strony zewnętrzne ($EXTERNAL) bez odpowiedzi od ponad $OVERDUE_DAYS dni: $n"; add "$(print_list "$LATE")"; fi
fi

if [ -n "$GATE_PEOPLE" ] && [ "$ROLE" != "$GATE_ROLE" ]; then
  n=$(count_rows "$(waiting_on "$OPEN_ROWS" "$GATE_PEOPLE")")
  [ "$n" -gt 0 ] && add "Czeka na decyzję ($GATE_ROLE: $GATE_PEOPLE): $n spraw. Nie buduj wariantów, które od nich zależą; nowe sprawy dopisuj do rejestru ($REG)."
fi

# Decision gate: a row waiting on the gate role is marked closed, but its last change is not theirs.
if [ -n "$REF" ] && [ -n "$GATE_EMAILS" ]; then
  GATE=""
  while IFS="$TAB" read -r line id rest; do
    [ -n "$line" ] || continue
    author="$(git blame -L "$line,$line" --porcelain "$REF" -- "$REG" 2>/dev/null | awk '/^author-mail /{gsub(/[<>]/, "", $2); print tolower($2); exit}')"
    if [ -n "$author" ] && ! printf '%s\n' "$GATE_EMAILS" | grep -qxF "$author"; then GATE="${GATE}${id} "; fi
  done <<EOF_GATE
$(waiting_on "$ROWS" "$GATE_PEOPLE" | awk -F'\t' -v closed="$CLOSED" 'index($6, closed) == 1 { print $1 "\t" $2 }')
EOF_GATE
  [ -n "$GATE" ] && add "Bramka decyzyjna: sprawy oznaczone jako rozstrzygnięte bez commita osoby z rolą $GATE_ROLE: ${GATE}— traktuj je jako propozycje do czasu potwierdzenia."
fi

# Stale clone and unsaved knowledge.
if [ -n "$REF" ]; then
  behind=$(git rev-list --count "HEAD..$REF" 2>/dev/null || echo 0)
  [ "$(int "$behind" 0)" -gt 0 ] && add "Klon jest $behind commitów za $REF: zaktualizuj go przed edycją wspólnych plików."
fi
OLDIFS="$IFS"; IFS=','
# shellcheck disable=SC2086
set -- $KNOWLEDGE_DIRS
IFS="$OLDIFS"
if [ "$#" -gt 0 ]; then
  dirty=$(git status --porcelain -- "$@" 2>/dev/null | wc -l | tr -d ' ')
  [ "$(int "$dirty" 0)" -gt 0 ] && add "Niezapisane w gicie zmiany w $KNOWLEDGE_DIRS: $dirty plików. Zapisz je według zasad repo."
fi

[ "$CHANGED_BY_OTHER" -eq 1 ] && add "Rejestr na $UPSTREAM zmienił się od ostatniego przypomnienia (ostatni commit: ${REG_LAST_AUTHOR:-?})."

[ -n "$ASK_PERSON" ] && add "$ASK_PERSON"

echo "$NOW" > "$STATE/last_reminder"
[ -n "$OUT" ] || exit 0

echo "[Przypomnienia z rejestru projektu $PROJECT ($REG), osoba: ${PERSON:-nieznana}]"
printf '%s' "$OUT"
echo "Zacznij odpowiedź od tych punktów w $SUMMARY_LINES liniach, potem wykonaj zadanie."
exit 0
