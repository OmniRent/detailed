# detailed — instrukcje dla Claude w repozytorium standardu

To repozytorium jest źródłem skilla `detailed`: ogólnych ram prowadzenia projektu dla klienta (zmiany, pytania i odpowiedzi, dokumentacja każdego kroku, komunikacja z klientem). Wersja alfa. Skill ma sprawić, że tych zasad nie trzeba powtarzać w każdej sesji.

## Czytaj najpierw

1. `README.md` — co jest w repo i jak się go używa.
2. `skills/detailed/SKILL.md` — skill; reszta w `skills/detailed/references/`.
3. `rejestr.md` — otwarte sprawy standardu (`STD-nn`).
4. `log-zdarzen.md` — co i kiedy się zmieniło.

## Główna zasada: uwaga o sposobie pracy staje się instrukcją w skillu

Uwaga o cyklu pracy (realizacja, dokumentacja, komunikacja, kolejność kroków) zgłoszona w dowolnej sesji, w tym repo albo w projekcie, nie zostaje w czacie i nie jest poprawką dla jednego projektu. Trafia tutaj, w postaci ogólnej, jako instrukcja dla Claude.

Przy każdej takiej uwadze:

1. **Uogólnij.** Zapisz regułę tak, jak brzmiałaby w innym projekcie: role zamiast imion, „klient” i „system zewnętrzny” zamiast nazw, klucze konfiguracji zamiast ścieżek.
2. **Znajdź miejsce** według tabeli niżej. Najpierw popraw istniejącą regułę; nową dopisuj tylko wtedy, gdy żadna jej nie obejmuje.
3. **Rozstrzygnij tryb.** Uwaga jednoznaczna i niesprzeczna z istniejącą regułą: zmień skill. Uwaga wymagająca decyzji, sprzeczna z regułą albo z zasadami innej osoby z zespołu: wiersz `STD-nn` w `rejestr.md` z założeniem roboczym; skill zmienia się po odpowiedzi.
4. **Zapisz ślad.** Zmiana skilla ma wpis `zmiana` w `log-zdarzen.md` (co od teraz obowiązuje, z jakiej sytuacji wynikło, bez nazw klienta). Odpowiedź na sprawę z rejestru ma wpis `decyzja` i status w wierszu.
5. **Sprawdź.** `bash tests/selftest.sh` kończy się „ALL OK”. Zmiana w hooku ma nowe sprawdzenie w tym teście.
6. **Wersja.** Zmiana zasad podnosi wersję w nagłówku `SKILL.md`.

| Uwaga dotyczy | Miejsce |
|---|---|
| kolejności i kształtu kroku, raportu kroku, tego, co zapisać po zdarzeniu | `skills/detailed/SKILL.md` |
| rejestru, dokumentów wiedzy, stanu, mapy wiedzy | `references/zapis-dla-nas.md` |
| treści dla klienta, wysyłki, odpowiedzi klienta, spotkań | `references/zapis-dla-klienta.md` |
| logu zdarzeń i dziennika zmian | `references/log-zdarzen.md` |
| decyzji, zakresu, różnic specyfikacja ↔ projekt | `references/bramka-i-zakres.md` |
| planu etapu, kart zadań, PR, recenzji, odbioru | `references/cykl-realizacji.md` |
| zakładania zapisu w projekcie, konfiguracji, hooka | `references/wdrozenie.md`, `templates/`, `scripts/` |

## Granice

- W `skills/detailed/` nie ma nazw klientów, systemów, osób ani ścieżek z żadnego projektu. Nazwy z nowego projektu dopisz do `tests/project-words.txt`.
- W całym repo nie ma nazw klientów, kwot ani treści z repozytoriów projektów. Przykłady są zmyślone i neutralne.
- Kopii skilla w repozytoriach projektów nie poprawia się na miejscu; zmiana powstaje tutaj i jest stamtąd kopiowana.
- Fakt jednego projektu (ścieżka, osoba, limit, model przypisany do roli) należy do `CLAUDE.md` i konfiguracji tamtego projektu, nie do skilla.
- Reguła, która w projekcie zmienia zakres, kontakt z klientem albo to, kto zamyka sprawy, jest sprawą do rejestru (STD-01), nie cichą zmianą.

## Praca w tym repo

- Stosuj tu pętlę kroku ze skilla: przed zmianą przeczytaj otwarte wiersze `rejestr.md` dotyczące obszaru, po zmianie podaj raport kroku.
- Język: dokumenty po polsku; kod, komentarze, identyfikatory i commity po angielsku.
- Git: `main` jest gałęzią domyślną i bazą każdej zmiany. Gałąź roboczą zakładasz z `origin/main` i do `main` ona wraca; nie budujesz zmiany na innej, niescalonej gałęzi. Commit, push i scalenie na polecenie osoby prowadzącej sesję. Klon, do którego prowadzi dowiązanie w katalogu skilli osoby, po pracy zostaje na `main`. Commit: tytuł w trybie rozkazującym, treść mówi dlaczego, bez atrybucji AI. Reguły gita dla projektów są jeszcze otwarte (STD-02, STD-03).
- „Gotowe” wymaga wyniku `bash tests/selftest.sh` w odpowiedzi.
