# Bramka decyzyjna, zakres, spójność specyfikacji z projektem

## 1. Bramka decyzyjna

Rolę decyzyjną wskazuje `gate_role` w konfiguracji; osoby z tą rolą są w pliku osób.

1. Decyzja z zakresu zarządzania projektem obowiązuje dopiero wtedy, gdy jest w repo w commicie osoby decyzyjnej (albo w PR przez nią scalonym). Dotyczy: zakresu i pakietów, specyfikacji i założeń, harmonogramu, ustaleń i odpowiedzi dla klienta, priorytetów, wyceny i umowy.
2. Kwestia wymagająca tej osoby: od razu wiersz w rejestrze („Czeka na” ta osoba, data w „Od”, kolumna „Zakres”), założenie robocze, komentarz z ID w kodzie. Nie zostaje w czacie ani w prywatnej rozmowie.
3. Sesja innej osoby wpisuje `propozycja` z uzasadnieniem, nigdy `rozstrzygnięte`.
4. Ustalenie spoza repo (komunikator, telefon, spotkanie) nie obowiązuje, dopóki nie trafi do repo commitem osoby decyzyjnej. Kto je zna, dopisuje wiersz `propozycja` ze źródłem.
5. Ominięcie bramki tylko na wyraźne polecenie w sesji. Commit dostaje linię `Gate-override: <kto>, <powód>`, żeby wyjątek był w historii.
6. Decyzje techniczne w ramach zakresu (biblioteka, struktura kodu, schemat zgodny z modelem) podejmuje deweloper. Gdy zmieniają zakres, koszt, termin albo to, co widzi klient, są sprawą osoby decyzyjnej.

O autorstwie decyduje e-mail autora commita porównany z plikiem osób. To umowa i czytelna historia, nie blokada techniczna: hook przypomnień zgłasza sprawy zamknięte cudzym commitem, ale ich nie cofa.

## 2. Zakres

Wartości kolumny „Zakres” i to, które z nich wolno budować, definiuje `CLAUDE.md` repo.

- Budujesz tylko to, co jest w podstawie albo w pakiecie już kupionym. Płatne rozszerzenia i późniejsze etapy: architektura może je umożliwić, ale nie budujesz ich i nie wpisujesz do specyfikacji przed decyzją.
- Wymaganie spoza zakresu (z zadania, z projektu graficznego, od klienta): przerwij, dopisz wiersz i zgłoś w jednej linii: co, gdzie w zakresie (ID), dlaczego wykracza.

### Klasyfikacja nowego materiału

Każde nowe albo zmienione wymaganie z notatki, komentarza klienta, zmiany specyfikacji, projektu albo zadania w kodzie dostaje jedną klasę: `w zakresie`, `doprecyzowanie`, `rozszerzenie`, `zmiana etapu`, `uproszczenie`, `ryzyko`.

Przy `rozszerzenie` i `zmiana etapu` odpowiedź zaczyna się linią:

```
⚠ Zakres: <co> — <gdzie w zakresie, ID> — szacunek <h> h (wstępny) — rekomendacja: dopłata / wchłonąć / etap późniejszy
```

Szacunek liczysz metodą z oferty projektu i zawsze oznaczasz jako wstępny. Niewycenione rozszerzenie nie trafia do specyfikacji, arkusza zakresu ani briefu projektowego przed decyzją. Pozycje wchłonięte zostają zapisane z wartością, żeby dało się pokazać klientowi, co dostał bez dopłaty.

### Zgłaszaj bez pytania

| Warunek | Przykłady |
|---|---|
| Funkcja systemu zewnętrznego bez potwierdzenia testem | zachowanie znane tylko z dokumentacji dostawcy |
| Kwota liczona poza systemem źródłowym | cena albo opłata wyliczona u nas |
| Strona prawna | ochrona konsumenta, dane osobowe, faktury, dostępność; tylko wskazanie, bez porady |
| Praca przerzucana na wykonawcę albo na klienta | treści, migracja, tłumaczenia, porządki w danych |
| Nowa struktura | kolekcja, typ bloku, konfiguracja per podstrona |
| Strona trzecia | integracja, licencja |
| Termin | zmiana zagraża kamieniowi milowemu z migawki stanu |
| Kumulacja | suma pozycji wchłoniętych przekracza próg ustalony w projekcie |

## 3. Spójność specyfikacja ↔ projekt graficzny

- Każda różnica między specyfikacją a projektem jest wierszem rozjazdu w rejestrze: `wykryty` → `propozycja` (co poprawić: specyfikację czy projekt) → `rozstrzygnięte` (osoba decyzyjna) → wpisane.
- Wyzwalacze: nowy eksport projektu (porównaj listę ekranów, tokeny oraz dodane i usunięte ekrany z mapą ekran → funkcja), zmiana specyfikacji, zadanie interfejsu w kodzie.
- Ekran z elementem spoza zakresu od razu dostaje kolumnę „Zakres” i czeka na osobę decyzyjną.
- Specyfikację zmienia tylko osoba decyzyjna. W innej sesji proponujesz zmianę w rejestrze, nie w tekście specyfikacji.
- Projekt graficzny w repo jest materiałem źródłowym: nie edytujesz eksportów, kod produkcyjny piszesz od nowa z wartości tokenów.
