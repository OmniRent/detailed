# Zapis dla nas: rejestr, dokumenty wiedzy, stan, mapa

Zapis wewnętrzny czyta zespół i każda kolejna sesja, która nie ma pamięci poprzedniej. Ma odpowiadać na trzy pytania: co jest otwarte i na kogo czeka, co wiemy i skąd, gdzie to leży. Ścieżki pochodzą z `.claude/detailed.conf`.

## 1. Rejestr (`register`)

Jedno miejsce na sprawy czekające na osobę decyzyjną, na klienta i na zespół, na testy, zmiany specyfikacji i różnice między specyfikacją a projektem graficznym.

| Kolumna | Znaczenie |
|---|---|
| ID | Prefiks rodzaju sprawy i numer. Prefiksy definiuje `CLAUDE.md` repo. Numer to kolejny wolny, nadany po aktualizacji klonu. Istniejących ID nie zmieniamy |
| Sprawa | Jedno zdanie: czego dotyczy i co trzeba ustalić |
| Czeka na | Osoba z pliku osób albo strona zewnętrzna z `external_parties`. Tylko te wartości, bo po nich filtruje hook |
| Od | Data otwarcia, `RRRR-MM-DD` |
| Zakres | Wartości z `CLAUDE.md` repo (na przykład podstawa, pakiet kupiony, pakiet płatny, etap późniejszy, do oceny) |
| Założenie robocze | Co robi kod albo dokument do czasu rozstrzygnięcia |
| Następny krok | Jedna czynność i kto ją wykonuje |
| Blokuje | Co stoi, dopóki sprawa jest otwarta |
| Status | `otwarte` → `w toku` albo `propozycja` → `rozstrzygnięte DD.MM (kto)` |
| Źródło potwierdzenia | Commit, PR, wiadomość, notatka ze spotkania. Bez źródła nie ma „rozstrzygnięte” |

Zasady wierszy:

1. Jeden wiersz to jedna linia. Nowe wiersze na końcu sekcji. Bez znaku `|` w komórkach. Nie przeformatowuj całych tabel. Dzięki temu dwie sesje rzadko wchodzą sobie w drogę.
2. Wierszy nie usuwamy. Rozstrzygnięty zostaje na miejscu, a decyzja dostaje wpis w logu zdarzeń.
3. Sprawę osoby decyzyjnej zamyka tylko jej commit (`references/bramka-i-zakres.md`). W innej sesji wpisujesz `propozycja` z uzasadnieniem.
4. Założenie robocze oznacz w kodzie albo w dokumencie komentarzem z ID sprawy, żeby po decyzji dało się znaleźć wszystkie miejsca.
5. Pytanie do klienta jest wierszem „Czeka na” klienta i pozycją w pliku do wysłania (`references/zapis-dla-klienta.md`). Kolumna „Następny krok” wskazuje ten plik.
6. Pytanie zadane osobie w sesji, na które sesja czeka, jest wierszem „Czeka na” tę osobę, z rekomendacją w „Założenie robocze”. Pytanie zostawione tylko w czacie ginie między sesjami i nie trafia do przypomnień. Odpowiedź z sesji zapisujesz w wierszu, zanim ją wykonasz: status, a w „Źródło potwierdzenia” data i „odpowiedź w sesji”.

## 2. Dokumenty wiedzy (`knowledge_dirs`)

| Zasada | Jak |
|---|---|
| Najpierw istniejący plik | Dopisz do dokumentu, który już opisuje temat. Nowy plik tylko dla nowego tematu i od razu z wpisem w mapie wiedzy |
| Nazwa | Według reguły nazw z `CLAUDE.md` repo. Gdy jej nie ma: numer kolejny i 2–5 słów o treści; data w nazwie tylko dla migawki z jednego dnia (wyniki testów, ankieta) |
| Nagłówek | Tytuł z datą stanu. Pod nim: „Źródło:” (dokumentacja, pomiar, kod, decyzja) i dla kogo jest dokument. Dokument wewnętrzny mówi to wprost w pierwszej linii |
| Fakty a założenia | Każdy fakt oznaczony: `zmierzone`, `z dokumentacji`, `założenie`. Dokumentacji zewnętrznego systemu nie przepisuj jako faktu, dopóki nie została potwierdzona pomiarem |
| Forma | Tabele dla faktów, decyzji, porównań i list zadań. Zdania tam, gdzie potrzebna jest argumentacja |
| Decyzje | W dokumencie odesłanie do ID w rejestrze albo do wpisu w logu, nie kopia treści decyzji |
| Historia | Dokumentu historycznego nie przepisuj. Dopisz „Aktualizacja DD.MM” albo załóż nowy dokument i odeślij do niego. Zastąpiony dokument dostaje adnotację na górze |
| Pytania w dokumencie | Punkt rozstrzygnięty oznacz „rozstrzygnięte: kto, kiedy” i zostaw w tabeli |

## 3. Migawka stanu (`state`) i mapa wiedzy (`knowledge_map`)

- Migawka stanu mówi, co obowiązuje dziś: zakres, zmiany względem specyfikacji, harmonogram. Nie prowadzi listy spraw otwartych ani logu decyzji, od tego są rejestr i log.
- Mapa wiedzy ma jeden wiersz na plik: co zawiera, kto go zmienia, kiedy go aktualizować. Plik bez wpisu w mapie nie istnieje dla następnej sesji.

## 4. Hierarchia i sprzeczności

Kolejność ważności dokumentów określa `CLAUDE.md` repo. Sprzeczność między dokumentami jest sprawą do rejestru (nowy wiersz), a nie cichym wyborem jednej wersji.

## 5. Przekazania i dowody

- Praca przechodzi między osobami i sesjami przez pliki w repo (plan, karta zadania, opis PR, recenzja, wpis w logu), nie przez streszczenie w czacie.
- „Gotowe” wymaga dowodu zapisanego przy zmianie: wynik testów albo buildu, zrzuty dla interfejsu, wynik pomiaru dla integracji. Odbiór opiera się na dowodzie, nie na opisie wykonawcy.

## 6. Czego nie zapisujemy

Sekretów (klucze tylko w środowisku, w repo plik przykładowy z pustymi wartościami). Danych osobowych z systemów klienta i surowych odpowiedzi, które je zawierają. Nagrań i surowych transkrypcji. Preferencji osobistych jednej osoby (należą do jej ustawień, poza repo).
