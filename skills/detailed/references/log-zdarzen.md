# Log zdarzeń

Rejestr mówi, co jest otwarte. Log zdarzeń mówi, co się stało, od kiedy coś obowiązuje i skąd to wiemy. Jest dopisywany, nigdy przepisywany.

## 1. Kształt wpisu

Jeden wpis to jedna linia tabeli, najnowsze na górze (`templates/log-zdarzen.md`):

| Kolumna | Znaczenie |
|---|---|
| Data | `RRRR-MM-DD` dnia zdarzenia, nie dnia zapisu |
| Typ | jeden z typów z sekcji 2 |
| ID | sprawa z rejestru, numer PR albo `—` |
| Co się stało i co od teraz obowiązuje | jedno albo dwa zdania; skutek, nie opis pracy |
| Kto | człowiek, który zdecydował, odpowiedział, wysłał albo scalił; nigdy model |
| Źródło | commit, PR, wiadomość, notatka ze spotkania, plik z wynikami |

Wpis bez źródła nie powstaje. Wpis powstaje w tej samej zmianie co rzecz, którą opisuje.

## 2. Typy zdarzeń

| Typ | Kiedy | Co jeszcze zmienia się w tej samej zmianie |
|---|---|---|
| `decyzja` | człowiek rozstrzygnął sprawę | status i źródło w rejestrze; dokumenty, których decyzja dotyczy |
| `odpowiedź klienta` | klient odpowiedział albo dostarczył materiał | wiersz rejestru; dokument, którego dotyczy |
| `wysłano` | osoba wysyłająca wysłała coś klientowi | kopia w archiwum wysłanych; tag dla dokumentu z wersją |
| `zmiana` | scalono zmianę w kodzie, w projekcie graficznym albo w zasadach repo | dokumenty techniczne; mapa wiedzy przy nowym pliku |
| `pomiar` | wykonano test albo pomiar na systemie zewnętrznym | dokument wyników; wiersz testu w rejestrze |
| `zakres` | zmiana zakresu przyjęta, odrzucona albo przesunięta | rejestr; specyfikacja i wycena po decyzji |
| `korekta` | wcześniejszy wpis albo wysłana treść były błędne | wskazanie daty i ID poprawianego wpisu |

Otwarcie sprawy nie jest zdarzeniem logu: zapisuje je wiersz rejestru z datą w kolumnie „Od”.

## 3. Zasady

1. **Tylko dopisywanie.** Starego wpisu nie poprawiasz ani nie usuwasz. Błąd prostuje nowy wpis `korekta`.
2. **Decyzja ma parę.** Zamknięcie sprawy osoby decyzyjnej w rejestrze i wpis `decyzja` powstają w tym samym commicie tej osoby. W innej sesji przygotowujesz oba jako propozycję.
3. **Skutek, nie przebieg.** Wpis `zmiana` mówi, co system albo dokument robi inaczej. Kodu linia po linii nie opisuje, od tego jest diff.
4. **Bez danych osobowych i bez kwot ponad potrzebę.** Kwota trafia do logu tylko wtedy, gdy jest treścią decyzji.
5. **Jeden log na typ zdarzenia.** Miejsce wpisów wskazuje `event_log`. Projekt może trzymać część typów gdzie indziej (na przykład decyzje w sekcji rejestru, scalone zmiany w dzienniku realizacji). Wtedy podział opisuje tabela „Zdarzenie → co aktualizować” w `CLAUDE.md` repo i żaden typ nie ma dwóch miejsc.

## 4. Dłuższy wpis dla scalonej zmiany

Gdy projekt prowadzi dziennik realizacji, wpis `zmiana` ma tam 3–6 linii w stałym kształcie:

```markdown
## <data> · PR #<n> · <ID zadania> <nazwa>
Zmiana: <co system robi inaczej>
Dokumenty: <pliki i sekcje zaktualizowane w tej zmianie>
Dowód: <wynik testów, zrzuty, pomiar>
Rejestr: <ID i nowy status> | bez zmian
```

## 5. Przykład

| Data | Typ | ID | Co się stało i co od teraz obowiązuje | Kto | Źródło |
|---|---|---|---|---|---|
| 2030-03-14 | `korekta` | K-07 | Wpis z 2030-03-12 podawał termin 20.03; poprawny termin z wiadomości klienta to 27.03 | Anna | wiadomość klienta z 2030-03-12 |
| 2030-03-13 | `wysłano` | K-07, K-09 | Lista pytań o dostęp do środowiska testowego wysłana klientowi; czekamy na odpowiedź | Anna | `wyslane/2030-03-13-pytania-dostep/` |
| 2030-03-12 | `decyzja` | P-04 | Eksport do arkusza poza pierwszym etapem; architektura ma go umożliwić, nie budujemy | Anna | commit `ab12cd3` |
| 2030-03-11 | `pomiar` | T-02 | Import 5 tys. rekordów trwa 4 min przy limicie 60 zapytań na minutę; partia 100 rekordów | Jan | `wyniki-testow-importu-2030-03-11.md` |
