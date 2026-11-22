# Wdrożenie w projekcie

Zakładanie zapisu w projekcie zmienia zasady pracy zespołu, więc jest sprawą osoby decyzyjnej: zaproponuj poniższe kroki i poczekaj na zgodę. Nie zakładaj plików bez niej.

W projekcie bez pliku osób zapytaj osobę prowadzącą sesję, kto pełni rolę decyzyjną i kto wysyła treści klientowi; od tych odpowiedzi zaczyna się plik osób. Do czasu wdrożenia nic nie ginie: stosujesz pętlę kroku, a w raporcie kroku wpisujesz, jaki wiersz, wpis albo plik powinien powstać.

## 1. Nowy projekt

| # | Co | Z czego | Gdzie w repo projektu |
|---|---|---|---|
| 1 | Konfiguracja z faktami projektu | `templates/detailed.conf` | `.claude/detailed.conf` |
| 2 | Plik osób: osoba, rola, e-maile z gita, wzorzec nazwy | `templates/osoby.tsv` | ścieżka z klucza `people` |
| 3 | Rejestr | `templates/rejestr.md` | ścieżka z klucza `register` |
| 4 | Log zdarzeń | `templates/log-zdarzen.md` | ścieżka z klucza `event_log` |
| 5 | Skrzynka nadawcza i archiwum wysłanych | puste katalogi z plikiem opisu | `client_outbox`, `client_sent` |
| 6 | Kopia skilla | katalog `skills/detailed/` z repozytorium standardu | `.claude/skills/detailed/` |
| 7 | Hook przypomnień | `templates/settings-hooks.json` | `.claude/settings.json` |
| 8 | Fakty w `CLAUDE.md` | lista w sekcji 3 | `CLAUDE.md` |

Po zgodzie, w katalogu projektu (`SKILL` to katalog tego skilla). Najpierw skopiuj konfigurację i wpisz w niej ścieżki projektu; resztę plików zakładasz pod ścieżkami z konfiguracji:

```bash
mkdir -p .claude/skills
cp -R "$SKILL" .claude/skills/detailed
cp "$SKILL/templates/detailed.conf" .claude/detailed.conf
# tu: uzupełnij .claude/detailed.conf
conf() { sed -n "s/^$1=//p" .claude/detailed.conf; }
for k in register event_log people; do mkdir -p "$(dirname "$(conf $k)")"; done
mkdir -p "$(conf client_outbox)" "$(conf client_sent)"
cp "$SKILL/templates/osoby.tsv" "$(conf people)"
cp "$SKILL/templates/rejestr.md" "$(conf register)"
[ "$(conf event_log)" = "$(conf register)" ] || cp "$SKILL/templates/log-zdarzen.md" "$(conf event_log)"
cp "$SKILL/templates/settings-hooks.json" .claude/settings.json   # gdy plik już istnieje: dopisz sekcję "hooks" ręcznie
```

Potem uzupełnij plik osób (`people`), dopisz fakty do `CLAUDE.md` (sekcja 3) i pierwszy wpis `decyzja` w logu: kto i kiedy przyjął standard.

Sprawdzenie: `bash .claude/skills/detailed/scripts/reminders.sh start` w katalogu projektu wypisuje sprawy czekające na osobę z `git config` albo pyta, kto prowadzi sesję.

## 2. Projekt, który ma już swoje pliki

1. Nie przenoś i nie przenumerowuj. Wpisz istniejące ścieżki do konfiguracji; nazwy kolumn rejestru podaj w kluczach `col_*`, statusy w kluczach `status_*`, limity cyklu realizacji w `plan_max_tasks`, `task_max_days`, `review_max_cycles`, `acceptance_max_cycles`.
2. Gdy log jest podzielony (decyzje w jednym miejscu, scalone zmiany w innym), `event_log` wskazuje miejsce decyzji, a podział opisuje tabela „Zdarzenie → co aktualizować” w `CLAUDE.md`.
3. Plik osób musi mieć kolumnę roli. Osoba z kilkoma adresami e-mail w gicie ma je wszystkie w kolumnie e-maili, po przecinku.
4. Zasady procesu skopiowane wcześniej do `CLAUDE.md` zastąp odesłaniem do skilla. W `CLAUDE.md` zostają fakty.

## 3. Co zostaje w `CLAUDE.md` projektu (fakty, nie proces)

- Osoby i role; kto prowadzi który rodzaj sesji i gdzie jest opisany jego sposób pracy.
- „Czytaj najpierw”: kolejność dokumentów.
- Hierarchia dokumentów przy sprzeczności.
- Zakres: wartości kolumny zakresu, co budujemy, czego nie; format linii zakresu (szacunek, kwota, rekomendacje) i warunki zgłaszania bez pytania (`references/bramka-i-zakres.md`, sekcja 2).
- Środowisko albo obiekty testowe systemów zewnętrznych; co porównać przy nowym eksporcie w katalogu `design`.
- Prefiksy ID w rejestrze i reguła nazw plików wiedzy.
- Tabela „Zdarzenie → co aktualizować” z konkretnymi plikami projektu.
- Git: gałąź domyślna, co idzie przez PR, kto scala, kiedy sesja commituje i wypycha, zasada autorstwa commitów.
- Poufność: co nigdy nie trafia do klienta ani do repo.
- Zasady architektury i weryfikacji właściwe dla projektu.

## 4. Kopia w projekcie a instalacja u osoby

| Sposób | Kiedy | Uwaga |
|---|---|---|
| Kopia w `.claude/skills/detailed/` w repo projektu | zawsze, gdy z projektem pracują sesje w chmurze albo kilka osób | sesja w chmurze widzi tylko repo; kopię robi się i aktualizuje z gałęzi domyślnej repozytorium standardu, nigdy z gałęzi roboczej; nie poprawia się jej na miejscu |
| Dowiązanie w katalogu skilli osoby do klonu repozytorium standardu | praca nad samym standardem | zmiany widać od razu we wszystkich projektach tej osoby |

Hook można też podpiąć w ustawieniach osoby: w repo bez `.claude/detailed.conf` skrypt milczy.

## 5. Założenia i ograniczenia hooka

- Czyta rejestr z gałęzi domyślnej na zdalnym repo; zmiany lokalne zobaczy po wypchnięciu.
- Na starcie sesji wykonuje `git fetch`; przy wiadomościach najwyżej raz na `fetch_interval_min` minut, w tle.
- Wiersze rejestru trafiają do kontekstu sesji. Każdy, kto może zmienić rejestr na gałęzi domyślnej, wpływa więc na to, co sesja przeczyta na początku: prawo zapisu do tej gałęzi mają tylko osoby z pliku osób.
- Osobę rozpoznaje po e-mailu z `git config`, potem po wzorcu nazwy. Zmienna `DETAILED_PERSON` wskazuje osobę bez pytania.
- Bramka decyzyjna jest umową: hook zgłasza sprawy zamknięte cudzym commitem, niczego nie blokuje i nie cofa.
- Zawsze kończy się kodem 0 i nigdy nie zatrzymuje pracy.
