# Bramka decyzyjna, zakres, spójność specyfikacji z projektem

## 1. Bramka decyzyjna

Rolę decyzyjną wskazuje `gate_role` w konfiguracji; osoby z tą rolą są w pliku osób.

1. Decyzja z zakresu zarządzania projektem obowiązuje dopiero wtedy, gdy jest w repo w commicie osoby decyzyjnej (albo w PR przez nią scalonym). Obszary bramki wymienia `CLAUDE.md` repo; gdy ich nie wymienia: zakres, specyfikacja i założenia, harmonogram, ustalenia i odpowiedzi dla klienta, priorytety, wycena i umowa.
2. Kwestia wymagająca tej osoby: od razu wiersz w rejestrze (`col_waiting` ta osoba, data w `col_since`, wartość w `col_scope`), założenie robocze, komentarz z ID w kodzie. Nie zostaje w czacie ani w prywatnej rozmowie.
3. Sesja innej osoby wpisuje status propozycji (`status_proposal`) z uzasadnieniem, nigdy status zamknięcia (`status_closed`).
4. Ustalenie spoza repo (komunikator, telefon, spotkanie) nie obowiązuje, dopóki nie trafi do repo commitem osoby decyzyjnej. Kto je zna, dopisuje wiersz ze statusem propozycji i źródłem.
5. Ominięcie bramki tylko na wyraźne polecenie w sesji. Commit dostaje linię `Gate-override: <kto>, <powód>`, żeby wyjątek był w historii.
6. Decyzje techniczne w ramach zakresu (biblioteka, struktura kodu, schemat zgodny z modelem) podejmuje deweloper. Gdy zmieniają zakres, koszt, termin albo to, co widzi klient, są sprawą osoby decyzyjnej.

O autorstwie decyduje e-mail autora commita porównany z plikiem osób. To umowa i czytelna historia, nie blokada techniczna: hook przypomnień zgłasza sprawy zamknięte cudzym commitem, ale ich nie cofa.

## 2. Zakres

Wartości kolumny zakresu (`col_scope`) i to, które z nich wolno budować, definiuje `CLAUDE.md` repo.

- Budujesz tylko to, co `CLAUDE.md` oznacza jako budowane. Pozostałe wartości: architektura może je umożliwić, ale nie budujesz ich i nie wpisujesz do specyfikacji przed decyzją.
- Wymaganie spoza zakresu (z zadania, z projektu graficznego, od klienta): przerwij, dopisz wiersz i zgłoś w jednej linii: co, gdzie w zakresie (ID), dlaczego wykracza.

### Klasyfikacja nowego materiału

Każde nowe albo zmienione wymaganie z notatki, komentarza klienta, zmiany specyfikacji, projektu albo zadania w kodzie dostaje jedną klasę: `w zakresie`, `doprecyzowanie`, `rozszerzenie`, `zmiana etapu`, `uproszczenie`, `ryzyko`.

Przy `rozszerzenie` i `zmiana etapu` odpowiedź zaczyna się linią zakresu. Jej format (szacunek, kwota, możliwe rekomendacje) podaje `CLAUDE.md` repo albo dokument, do którego odsyła. Gdy go nie podaje:

```
⚠ Zakres: <co> — <gdzie w zakresie, ID> — rekomendacja: <co proponujesz>
```

Szacunek, jeśli projekt go wymaga, liczysz metodą wskazaną w projekcie i zawsze oznaczasz jako wstępny. Niewycenione rozszerzenie nie trafia do specyfikacji, arkusza zakresu ani briefu projektowego przed decyzją. Pozycja przyjęta bez dopłaty zostaje zapisana z wartością, żeby dało się pokazać klientowi, co dostał.

### Zgłaszaj bez pytania

Warunki, które zgłaszasz od razu (linia zakresu albo wiersz rejestru, bez czekania na pytanie), wymienia `CLAUDE.md` repo: systemy zewnętrzne, sprawy prawne, struktury wymagające decyzji, progi i terminy właściwe dla projektu. Gdy projekt ich nie wymienia, zgłaszasz co najmniej:

- zachowanie systemu zewnętrznego znane tylko z dokumentacji, bez potwierdzenia testem;
- pracę przerzucaną na wykonawcę albo na klienta;
- nową integrację albo licencję;
- sprawę prawną (tylko wskazanie, bez porady);
- zagrożenie terminu z migawki stanu (`state`).

## 3. Spójność specyfikacja ↔ projekt graficzny

Obowiązuje, gdy konfiguracja wskazuje katalog projektu graficznego (`design`). Bez niego tę sekcję pomijasz.

- Każda różnica między specyfikacją a projektem jest wierszem rozjazdu w rejestrze: wykryty → propozycja (co poprawić: specyfikację czy projekt) → zamknięty przez osobę decyzyjną → wpisany.
- Wyzwalacze: nowy eksport w katalogu `design` (co porównać, mówi `CLAUDE.md` repo), zmiana specyfikacji, zadanie interfejsu w kodzie.
- Ekran z elementem spoza zakresu od razu dostaje wartość w `col_scope` i czeka na osobę decyzyjną.
- Specyfikację zmienia tylko osoba decyzyjna. W innej sesji proponujesz zmianę w rejestrze, nie w tekście specyfikacji.
- Eksportów w katalogu `design` nie edytujesz; są materiałem źródłowym.
