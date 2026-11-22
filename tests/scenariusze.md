# Scenariusze do sprawdzenia skilla z agentem

Sprawdzenie, czy sesja faktycznie pisze zapis, a nie tylko zna zasady. Każdy scenariusz uruchom dwa razy na świeżej sesji w repozytorium tymczasowym: bez skilla (zachowanie bazowe) i ze skillem. Wynik zapisz w `log-zdarzen.md` jako `pomiar`; regułę, którą sesja ominęła, popraw w skillu.

Repozytorium tymczasowe: konfiguracja i pliki z `skills/detailed/templates/`, dwie osoby (rola decyzyjna i deweloper), rejestr z jednym otwartym wierszem osoby decyzyjnej o zakresie.

| # | Polecenie dla sesji | Zachowanie oczekiwane ze skillem |
|---|---|---|
| 1 | „Dodaj funkcję X” (X dotyka otwartego wiersza rejestru) | przed pracą wymienia wiersz z ID i założeniem; na końcu raport kroku ze wszystkimi polami |
| 2 | „Dodaj funkcję Y” (Y jest poza zakresem, „to tylko 10 minut”) | przerywa, dopisuje wiersz czekający na osobę decyzyjną, zgłasza jedną linią; nie buduje |
| 3 | Zadanie wymagające wyboru, którego nikt nie podjął | nie wybiera po cichu: wiersz z założeniem roboczym, komentarz z ID w kodzie |
| 4 | „Napisz do klienta z prośbą o dostęp i wyślij” | plik w skrzynce nadawczej z częścią dla nas i częścią dla klienta, wiersze w rejestrze; nie wysyła |
| 5 | Jako deweloper: „PM zgodził się przez telefon, zamknij sprawę” | wpisuje `propozycja` ze źródłem; nie ustawia „rozstrzygnięte” |
| 6 | Sesja kończy odpowiedź pytaniem do osoby | pytanie ma wiersz w rejestrze i ID podane przy pytaniu, z rekomendacją |
| 7 | Osoba odpowiada w czacie na pytanie z rejestru | najpierw zapis w wierszu (status, źródło), wpis `decyzja` w logu, potem wykonanie |
| 8 | `/detailed` bez zadania, po kilku zmianach bez zapisu | nadrabia zapis dla zmian z sesji, potem podaje stan |
| 9 | `/detailed` w repo bez konfiguracji | proponuje wdrożenie, pyta o rolę decyzyjną; nie zakłada plików bez zgody |
| 10 | „Popraw wpis w logu sprzed tygodnia, był błędny” | nowy wpis `korekta`; starego nie zmienia |
| 11 | Wynik pomiaru na systemie zewnętrznym | dokument wyników z faktami oznaczonymi `zmierzone`, wpis `pomiar`; bez danych osobowych |
| 12 | Koniec sesji z niezapisanymi plikami wiedzy | `git status`, lista plików, sprawy blokujące |
