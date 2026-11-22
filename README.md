# detailed: standard zapisu pracy projektowej

Repozytorium jest źródłem skilla `detailed` dla Claude Code. Skill prowadzi każdą sesję pracy nad projektem dla klienta tak, żeby każdy krok zostawił ślad w trzech rodzajach zapisu:

| Zapis | Opis zasad |
|---|---|
| Dla nas (rejestr spraw, dokumenty wiedzy, stan, mapa) | [skills/detailed/references/zapis-dla-nas.md](skills/detailed/references/zapis-dla-nas.md) |
| Dla klienta (przygotowanie, wysyłka, archiwum, odpowiedź) | [skills/detailed/references/zapis-dla-klienta.md](skills/detailed/references/zapis-dla-klienta.md) |
| Log zdarzeń (decyzje, odpowiedzi, wysyłki, zmiany, pomiary) | [skills/detailed/references/log-zdarzen.md](skills/detailed/references/log-zdarzen.md) |

Proces jest w skillu. Fakty projektu (ścieżki, osoby, role, gałąź, klient) są w repo projektu: w `.claude/detailed.conf` i w `CLAUDE.md`. W katalogu `skills/detailed/` nie ma nazw z żadnego projektu i pilnuje tego test.

## Zawartość

| Ścieżka | Co to jest |
|---|---|
| `skills/detailed/SKILL.md` | Skill: pętla kroku, tabela „zdarzenie → zapis”, czerwone linie, raport kroku |
| `skills/detailed/references/` | Zasady trzech rodzajów zapisu, bramka decyzyjna i zakres, cykl realizacji, wdrożenie w projekcie |
| `CLAUDE.md` | Instrukcje dla Claude w tym repo: jak uwagi o sposobie pracy stają się regułami skilla |
| `skills/detailed/templates/` | Konfiguracja projektu, plik osób, rejestr, log zdarzeń, plik do wysłania, podpięcie hooka |
| `skills/detailed/scripts/reminders.sh` | Hook przypomnień z rejestru; wszystko czyta z konfiguracji projektu |
| `tests/selftest.sh` | Sprawdzenie hooka na repozytorium tymczasowym i brak słów z projektów w skillu |
| `tests/project-words.txt` | Słowa, które nie mogą pojawić się w skillu; dopisz nazwy z każdego nowego projektu |
| `rejestr.md` | Otwarte sprawy samego standardu |
| `log-zdarzen.md` | Co i kiedy zmieniło się w standardzie |

## Użycie

W sesji Claude Code: `/detailed` albo samo rozpoczęcie pracy w repo, które ma `.claude/detailed.conf`.

Instalacja u osoby pracującej nad standardem (zmiany widać od razu we wszystkich projektach):

```bash
ln -s "$(pwd)/skills/detailed" ~/.claude/skills/detailed
```

Kopia w repo projektu (potrzebna, gdy z projektem pracują sesje w chmurze albo kilka osób):

```bash
cp -R skills/detailed <repo-projektu>/.claude/skills/detailed
```

Pierwsze wdrożenie w projekcie: [skills/detailed/references/wdrozenie.md](skills/detailed/references/wdrozenie.md).

## Rozwój

Standard powstaje w pracy nad projektami i wraca tutaj w postaci ogólnej.

1. Obserwacja z projektu przychodzi z pola „Do standardu” raportu kroku: reguła zapisana tak, jak brzmiałaby w innym projekcie, bez nazw klienta, systemów i osób.
2. Sprawa otwarta trafia do [rejestr.md](rejestr.md); przyjęta zmiana do skilla i do [log-zdarzen.md](log-zdarzen.md).
3. Przed zapisaniem zmiany: `bash tests/selftest.sh` kończy się „ALL OK”.
4. Zmiana zasad podnosi wersję w nagłówku `SKILL.md`. Bazą każdej zmiany jest `main`; kopie w projektach robi się i aktualizuje z `main`, a kopii nie poprawia się na miejscu.

## Pochodzenie

Wersja 0.1.0 uogólnia standard pracy projektu 1.0 z 22.11.2026 przygotowany przez PM dla jednego projektu (jeden rejestr, bramka decyzyjna przez commit, spójność specyfikacji z projektem graficznym, mapa wiedzy, hook przypomnień) oraz zasady pisania dokumentacji i dziennika realizacji z tego samego projektu.
