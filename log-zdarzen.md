# Log zdarzeń standardu

Tylko dopisujemy, najnowsze na górze. Zasady i typy: [skills/detailed/references/log-zdarzen.md](skills/detailed/references/log-zdarzen.md).

| Data | Typ | ID | Co się stało i co od teraz obowiązuje | Kto | Źródło |
|---|---|---|---|---|---|
| 2026-11-22 | `zmiana` | — | Wersja 0.2.0: pytanie, na które sesja czeka, jest wierszem rejestru z rekomendacją i ID podanym przy pytaniu; raport kroku ma pole „Czeka na Ciebie”; odpowiedź z sesji jest zapisywana w wierszu przed wykonaniem. Powód: pytania zadawane na końcu odpowiedzi w czacie ginęły między turami i nie trafiały do przypomnień | Olek | uwaga w sesji 22.11 |
| 2026-11-22 | `decyzja` | STD-05 | Skill instalujemy u dewelopera dowiązaniem w katalogu skilli osoby; dla pierwszego projektu przygotowujemy PR z wdrożeniem (konfiguracja, rola w pliku osób, podmiana hooka, `CLAUDE.md` bez kopii procesu) | Olek | odpowiedź w sesji 22.11 |
| 2026-11-22 | `decyzja` | STD-09 | Na standardzie zbudujemy później żywą kolejkę zadań z przypomnieniami; do tego czasu miejscem na pytania jest rejestr | Olek | odpowiedź w sesji 22.11 |
| 2026-11-22 | `decyzja` | STD-04 | Standard ma zdalne, prywatne repozytorium i w nim prowadzimy rozwój skilla; konto docelowe i dostęp drugiej osoby pozostają otwarte | Olek | polecenie w sesji 22.11 |
| 2026-11-22 | `pomiar` | STD-05 | Hook w wersji ogólnej uruchomiony na rejestrze pierwszego projektu z konfiguracją spoza repo: listy spraw dla dewelopera i dla PM identyczne z hookiem 1.0, różnią się tylko nagłówki komunikatów; osoba rozpoznana po drugim adresie e-mail | Olek | sesja 22.11; `bash tests/selftest.sh`: ALL OK (18 sprawdzeń) |
| 2026-11-22 | `zmiana` | — | Wersja 0.1.0 (alfa): skill `detailed` z pętlą kroku i raportem kroku, zasady zapisu dla nas, dla klienta i logu zdarzeń, bramka decyzyjna i zakres, cykl realizacji, wdrożenie, szablony, hook przypomnień czytający konfigurację projektu, test; `CLAUDE.md` repo z zasadą, że uwagi o sposobie pracy trafiają do skilla w postaci ogólnej | Olek | pierwszy commit repozytorium |
| 2026-11-22 | `decyzja` | — | Standard pracy projektowej ma własne repozytorium i jest skillem wywoływanym jako `/detailed`. Proces nie zawiera nazw z projektów; fakty projektu są w konfiguracji i `CLAUDE.md` repo projektu; standard jest uogólniany na bieżąco z pracy nad projektami | Olek | polecenie w sesji 22.11 |
