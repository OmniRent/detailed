# Zapis dla klienta: przygotowanie, wysyłka, archiwum, odpowiedź

Klient widzi tylko to, co wysłała osoba z rolą `sender_role`. Sesja przygotowuje treść w pliku i na tym kończy. Repo projektu nie trafia do klienta w żadnej formie.

## 1. Przebieg

| Etap | Co powstaje | Kto |
|---|---|---|
| Przygotowanie | plik w skrzynce nadawczej (`client_outbox`), według `templates/do-wyslania.md` | sesja |
| Sprawy w rejestrze | każde pytanie i każda prośba z pliku ma wiersz „Czeka na” klienta; „Następny krok” wskazuje plik | sesja |
| Wysyłka | wiadomość do klienta | tylko osoba wysyłająca |
| Archiwum | kopia tego, co faktycznie wysłano, w `client_sent/RRRR-MM-DD-<co>/`; wpis `wysłano` w logu zdarzeń | osoba wysyłająca albo jej sesja |
| Odpowiedź | wpis `odpowiedź klienta` w logu; wiersze rejestru; dokument, którego odpowiedź dotyczy | sesja osoby, która odpowiedź dostała |

## 2. Plik do wysłania

Nazwa według reguły nazw z `CLAUDE.md` repo; gdy jej nie ma: `RRRR-MM-DD-<temat>.md` w skrzynce nadawczej. Jeden plik to jedna wiadomość.

Plik ma dwie części rozdzielone linią `---`.

**Nad linią (dla nas):** do kogo, kto wysyła, których ID z rejestru dotyczy, na jakiej podstawie powstał.

**Pod linią (dla klienta):** wyłącznie tekst, który można wkleić do wiadomości bez redakcji. Kształt każdej prośby:

1. Czego potrzebujemy (jedno zdanie).
2. Po co (co to odblokowuje po stronie klienta).
3. Co to oznacza po jego stronie (praca, zgoda, ryzyko, kto jeszcze to zobaczy).
4. Do kiedy, jeśli termin istnieje.

Jedna wiadomość to jedna lista spraw. Język klienta, zwykłe słowa, bez skrótów zespołu.

## 3. Czego nie ma pod linią

| Nie wpisuj | Dlaczego |
|---|---|
| Wewnętrznych ID, nazw plików i gałęzi | Klient ich nie zna; zostają nad linią |
| Stawek, marż, szacunków i kwot, których klient jeszcze nie dostał w ofercie | Kwoty wychodzą tylko w dokumentach handlowych, decyzją osoby decyzyjnej |
| Wątpliwości zespołu, ocen klienta, notatek o innych klientach | To zapis dla nas |
| Danych dostępowych, danych osobowych, fragmentów surowych transkrypcji | Poufność |
| Porad prawnych | Sprawy prawne tylko wskazujemy; potwierdza prawnik klienta |
| Obietnic poza zakresem | Zakres zmienia tylko decyzja (`references/bramka-i-zakres.md`) |

Przed oddaniem pliku przeczytaj część pod linią tak, jak przeczyta ją klient, i sprawdź tę tabelę punkt po punkcie.

## 4. Dokumenty z wersją (specyfikacja, oferta, zakres)

- Wersja wysłana klientowi dostaje tag w gicie według `sent_tag_format` i kopię w archiwum wysłanych.
- Archiwum wysłanych nie jest nadpisywane, także przez skrypty budujące dokumenty. Nowa wersja to nowy katalog z datą.
- Nowa wersja zaczyna się sekcją „Zmiany w wersji X”.
- Treść takich dokumentów zmienia tylko osoba decyzyjna. W innej sesji proponujesz zmianę w rejestrze, nie w tekście.

## 5. Odpowiedź klienta

1. Wpis `odpowiedź klienta` w logu zdarzeń: data, czego dotyczy, kto odpowiedział, źródło (wiadomość, notatka ze spotkania, komentarz).
2. Wiersz rejestru: gdy odpowiedź zamyka sprawę, status ustawia osoba decyzyjna; w innej sesji wpisujesz status propozycji (`status_proposal`) ze źródłem.
3. Ustalenie spoza repo (komunikator, telefon, spotkanie) nie obowiązuje, dopóki osoba decyzyjna nie zapisze go commitem.
4. Odpowiedź, która zmienia zakres, koszt albo termin, jest nową sprawą dla osoby decyzyjnej, nie poleceniem do wykonania.

## 6. Spotkania i materiały od klienta

- Nagrania i surowe transkrypcje zostają poza repo. Do repo trafia transkrypcja po przeglądzie (bez danych dostępowych i danych osobowych spoza projektu) albo samo podsumowanie.
- Klient dostaje tylko podsumowania, nigdy transkrypcję.
- Ustalenia ze spotkania stają się wierszami rejestru i wpisami w logu w dniu, w którym powstały.

## 7. Przekazanie kodu

Kod przekazujemy klientowi osobnym repozytorium z samym kodem, bez historii repo projektu.
