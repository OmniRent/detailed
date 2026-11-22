---
name: detailed
description: Używaj, gdy pracujesz w repozytorium projektu dla klienta, które ma plik `.claude/detailed.conf`, albo gdy osoba wpisze /detailed - przed rozpoczęciem zadania, gdy pojawia się pytanie, decyzja, wątpliwość co do zakresu albo treść dla klienta, po każdej zmianie, którą trzeba zapisać, i na końcu sesji. Także gdy trzeba założyć taki zapis w nowym projekcie. Hasła - rejestr pytań i decyzji, log zdarzeń, bramka decyzyjna, treść do wysłania klientowi, dokumentowanie kroku.
---

# detailed: dokładny zapis każdego kroku pracy projektowej

Wersja 0.2.0, alfa (22.11.2026).

**Zasada.** Nic, co ustalono, zmieniono albo wysłano, nie zostaje tylko w czacie. Każdy krok zostawia ślad w trzech rodzajach zapisu:

| Zapis | Dla kogo | Co zawiera | Szczegóły |
|---|---|---|---|
| **Dla nas** | zespół i kolejne sesje | rejestr spraw, dokumenty wiedzy, migawka stanu, mapa wiedzy | `references/zapis-dla-nas.md` |
| **Dla klienta** | klient, przez osobę wysyłającą | treść przygotowana do wysłania i archiwum tego, co wysłano | `references/zapis-dla-klienta.md` |
| **Log zdarzeń** | każdy, kto pyta „od kiedy i skąd to wiemy” | decyzje, odpowiedzi klienta, wysyłki, zmiany, pomiary | `references/log-zdarzen.md` |

**Proces jest tutaj, fakty są w projekcie.** Ścieżki, osoby, role, gałąź i strony zewnętrzne czytasz z `.claude/detailed.conf`; zakres, hierarchię dokumentów i zasady gita z `CLAUDE.md` repo. Ten skill nie zawiera nazw z żadnego projektu. Gdy `CLAUDE.md` repo albo zasady osoby prowadzącej sesję są ostrzejsze niż skill, stosuj je i zgłoś różnicę w raporcie kroku (pole „Do standardu”).

## Pętla kroku

Krok to jedna logiczna zmiana: zadanie, odpowiedź na pytanie, analiza materiału, przygotowanie treści.

### Przed krokiem

1. **Konfiguracja.** Przeczytaj `.claude/detailed.conf`. Gdy go nie ma: `references/wdrozenie.md`.
2. **Kto prowadzi sesję.** `git config user.email` i `user.name` porównaj z plikiem osób (`people`). Osoba nieznana: zapytaj raz. Od osoby zależy rola i to, co wolno zamknąć.
3. **Aktualny stan.** Zaktualizuj klon według zasad repo. Przeczytaj w rejestrze (`register`) otwarte wiersze dotykające obszaru kroku i wymień je, po jednej linii: ID, czego dotyczy, założenie robocze.
4. **Zakres.** Sprawdź, czy krok mieści się w zakresie (`references/bramka-i-zakres.md`). Poza zakresem: przerwij, wiersz w rejestrze, jedna linia zgłoszenia.

### W trakcie

5. **Kwestia nierozstrzygnięta.** Nie rozstrzygaj jej. Dopisz wiersz w rejestrze („Czeka na”, „Od”, „Zakres”, założenie robocze), buduj na założeniu i oznacz je komentarzem z ID w kodzie albo w dokumencie.
6. **Fakt.** Oznacz, skąd pochodzi: `zmierzone`, `z dokumentacji`, `założenie`.
7. **Treść dla klienta.** Przygotuj plik w skrzynce nadawczej (`client_outbox`). Nie wysyłaj.
8. **Pytanie do osoby.** Pytanie, na którego odpowiedź sesja czeka, dopisz w tej samej zmianie jako wiersz rejestru („Czeka na” ta osoba) z rekomendacją w kolumnie „Założenie robocze” i podaj jego ID przy pytaniu. Odpowiedź, która przyjdzie w sesji, najpierw zapisz w wierszu (status i źródło), potem wykonaj.

### Po kroku

9. **Zapis.** Znajdź zdarzenie w tabeli niżej i zaktualizuj wskazane miejsca w tej samej zmianie. Gdy `CLAUDE.md` repo ma własną tabelę „Zdarzenie → co aktualizować”, ona wskazuje pliki.
10. **Git.** Zapisz zmianę według zasad repo i osoby prowadzącej (kto commituje, co idzie przez PR, kiedy pytać). Skill mówi, co ma trafić do zapisu, a nie kto wypycha.
11. **Raport kroku** w tym kształcie, każde pole wypełnione:

```
Krok: <co zrobione, jedno zdanie>
Zapis dla nas: <pliki i sekcje> | brak (dlaczego)
Zapis dla klienta: <plik w skrzynce nadawczej> | brak
Log zdarzeń: <typ i ID każdego wpisu> | brak
Rejestr: <nowe i zmienione ID ze statusem> | bez zmian
Czeka na Ciebie: <ID i pytanie w jednym zdaniu, z rekomendacją> | nic
Blokuje: <ID otwartych spraw, które blokują dalszą pracę> | nic
Niezapisane w gicie: <pliki> | nic
Do standardu: <reguła w postaci ogólnej, bez nazw z projektu> | nic
```

## Zdarzenie → zapis

| Zdarzenie | Zapis dla nas | Log zdarzeń | Zapis dla klienta |
|---|---|---|---|
| Nowe pytanie albo sprawa | nowy wiersz w rejestrze | — | pytanie do klienta: pozycja w pliku do wysłania |
| Pytanie do osoby, na które sesja czeka | wiersz w rejestrze z rekomendacją; ID podane przy pytaniu | — | — |
| Odpowiedź osoby z zespołu na pytanie z rejestru | odpowiedź i źródło w wierszu; status według bramki; komentarze z ID w kodzie zastąpione rozstrzygnięciem | `decyzja`, gdy odpowiedź zamyka sprawę | — |
| Decyzja człowieka | status i źródło w rejestrze; dokumenty, których dotyczy | `decyzja` | gdy klient ma ją poznać: plik do wysłania |
| Odpowiedź albo materiał od klienta | wiersz rejestru; dokument, którego dotyczy | `odpowiedź klienta` | — |
| Wysłano coś klientowi | kopia w archiwum wysłanych (`client_sent`); wiersze rejestru | `wysłano` | plik przeniesiony ze skrzynki do archiwum |
| Scalona zmiana w kodzie albo w projekcie | dokumenty, których dotyczy | `zmiana` | — |
| Test albo pomiar | dokument wyników; fakty oznaczone `zmierzone` | `pomiar` | — |
| Wymaganie spoza zakresu | wiersz „Czeka na” osobę decyzyjną, z kolumną „Zakres” | `zakres` po decyzji | po decyzji |
| Różnica specyfikacja ↔ projekt graficzny | wiersz rozjazdu w rejestrze | — | — |
| Sprzeczność między dokumentami | wiersz w rejestrze, bez cichego wyboru | — | — |
| Nowy plik wiedzy | wpis w mapie wiedzy (`knowledge_map`) | — | — |
| Błąd w zapisie albo w wysłanej treści | dopisek z datą, bez przepisywania historii | `korekta` | sprostowanie w pliku do wysłania |

## Czerwone linie

- Sprawy osoby decyzyjnej (`gate_role`) zamyka tylko jej commit. Sesja innej osoby wpisuje `propozycja`.
- Nic nie wychodzi do klienta z sesji. Wysyła osoba z rolą `sender_role`.
- Jeden rejestr. Bez osobnych list pytań, bez kopii decyzji w innych plikach, bez pliku per zmiana.
- Log zdarzeń tylko dopisujemy. Wierszy rejestru nie usuwamy i nie przenumerowujemy.
- W repo nie ma sekretów, danych osobowych z systemów klienta, nagrań ani surowych transkrypcji.
- Poza zakresem nie budujemy i nie dopisujemy do specyfikacji przed decyzją. „Mały koszt” nie jest powodem.

## Co czytać i kiedy

| Plik | Kiedy |
|---|---|
| `references/zapis-dla-nas.md` | dopisujesz wiersz do rejestru, piszesz albo zmieniasz dokument wiedzy |
| `references/zapis-dla-klienta.md` | powstaje jakakolwiek treść, którą zobaczy klient, albo przyszła jego odpowiedź |
| `references/log-zdarzen.md` | zdarzenie z tabeli ma wpis w logu |
| `references/bramka-i-zakres.md` | decyzja, wątpliwość co do zakresu, różnica specyfikacja ↔ projekt |
| `references/cykl-realizacji.md` | planujesz etap, piszesz kartę zadania, opis PR albo recenzję, odbierasz etap |
| `references/wdrozenie.md` | repo nie ma konfiguracji albo zakładasz zapis w nowym projekcie |
| `templates/` | zakładasz rejestr, log, plik do wysłania, konfigurację, plik osób albo hook |
| `scripts/reminders.sh` | hook przypomnień; ręcznie: `bash scripts/reminders.sh start` w katalogu projektu |

## Przypomnienia

Gdy repo ma hook przypomnień, jego punkty podaj w 1–3 liniach na początku odpowiedzi (ID i czego dotyczy), potem rób zadanie; nie powtarzaj ich przy każdej odpowiedzi. Gdy hooka nie ma, zrób to sam na starcie sesji: sprawy czekające na osobę prowadzącą, sprawy stron zewnętrznych otwarte dłużej niż `external_overdue_days`, sprawy osoby decyzyjnej zamknięte bez jej commita, nieaktualny klon. Na końcu dłuższej sesji: sprawy, które blokują pracę.

## Rozwój standardu

Ten skill ma jedno źródło: własne repozytorium. Kopii w projekcie nie poprawiasz na miejscu. Gdy reguły brakuje, reguła się nie sprawdza albo zasady repo różnią się od skilla, wpisz to w pole „Do standardu” raportu kroku w postaci ogólnej (jak brzmiałaby w innym projekcie), bez nazw klienta, systemów i osób.
