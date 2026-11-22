# Rejestr pytań, spraw i decyzji

Dokument wewnętrzny. Nie wysyłać klientowi (treści dla klienta są w skrzynce nadawczej).

Jedyny rejestr projektu. Zasady: skill `detailed`, `references/zapis-dla-nas.md` i `references/bramka-i-zakres.md`. Prefiksy ID i wartości kolumny „Zakres”: `CLAUDE.md`.

| Kolumna | Znaczenie |
|---|---|
| Czeka na | osoba z pliku osób albo strona zewnętrzna z konfiguracji (tylko te wartości) |
| Od | data otwarcia, `RRRR-MM-DD` |
| Status | wartości `status_*` z konfiguracji (domyślnie: otwarte · w toku · propozycja · rozstrzygnięte DD.MM (kto)) |
| Źródło potwierdzenia | commit, PR, wiadomość, notatka ze spotkania; bez źródła nie ma statusu zamknięcia |

Jeden wiersz to jedna linia; nowe wiersze na końcu sekcji; bez znaku pionowej kreski w komórkach; wierszy nie usuwamy.

## 1. Czeka na osobę decyzyjną

| ID | Sprawa | Czeka na | Od | Zakres | Założenie robocze | Następny krok | Blokuje | Status | Źródło potwierdzenia |
|---|---|---|---|---|---|---|---|---|---|

## 2. Czeka na klienta

| ID | Sprawa | Czeka na | Od | Zakres | Założenie robocze | Następny krok | Blokuje | Status | Źródło potwierdzenia |
|---|---|---|---|---|---|---|---|---|---|

## 3. Czeka na zespół

| ID | Sprawa | Czeka na | Od | Zakres | Założenie robocze | Następny krok | Blokuje | Status | Źródło potwierdzenia |
|---|---|---|---|---|---|---|---|---|---|

## 4. Zmiany specyfikacji i różnice specyfikacja ↔ projekt graficzny

Różnice z projektem graficznym tylko wtedy, gdy konfiguracja wskazuje katalog `design`; bez niego sekcja zbiera same zmiany specyfikacji.

| ID | Sprawa | Czeka na | Od | Zakres | Założenie robocze | Następny krok | Blokuje | Status | Źródło potwierdzenia |
|---|---|---|---|---|---|---|---|---|---|
