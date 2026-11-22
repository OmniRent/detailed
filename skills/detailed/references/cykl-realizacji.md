# Cykl realizacji: od planu etapu do odbioru

Ramy pracy nad kodem i dokumentacją techniczną. Kto pełni którą rolę (człowiek albo który model), gdzie leżą plany i jakie limity obowiązują w projekcie, określa `CLAUDE.md` repo. Tu jest to, co wspólne.

## 1. Etapy i zapis, który po nich zostaje

| Etap | Rola | Zapis | „Gotowe” znaczy |
|---|---|---|---|
| Plan etapu | planista | plik planu: cel, zakres i co poza nim, zadania z kryterium akceptacji, ryzyka | każde zadanie ma cel, wejście (dokumenty i sekcje), kryterium sprawdzalne bez rozmowy z autorem, zależności i sprawy z rejestru, które go dotyczą |
| Akceptacja planu | człowiek | scalony plan; wpis `decyzja` w logu | — |
| Karta zadania | rola wskazana w projekcie | karta: cel, wejście, wyjście, testy, czego nie ruszać, dowód | wykonawca może zacząć bez pytań |
| Zmiana | wykonawca | jedna karta, jedna gałąź, jeden PR z opisem według szablonu | testy i lint przechodzą; dokumenty zaktualizowane w tej samej zmianie |
| Recenzja | recenzent | werdykt w PR | oparty na przeczytanym diffie i uruchomionych testach; każda uwaga wskazuje plik i linię |
| Scalenie | człowiek | wpis `zmiana` w logu albo w dzienniku realizacji | — |
| Odbiór etapu | planista | sekcja „Odbiór” w planie: kryteria ze statusem i dowodem | wszystkie kryteria potwierdzone dowodami; dokumentacja zgodna z kodem; rejestr aktualny |

## 2. Zasady

1. **Kryterium przed pracą.** Kryterium akceptacji jest zapisane, zanim zadanie się zacznie.
2. **Dowód, nie opis.** Akceptacja opiera się na testach, buildzie, zrzutach i pomiarach, nie na raporcie wykonawcy.
3. **Przekazania przez pliki.** Plan, karta, opis PR, recenzja i wpis w logu są w repo. Wykonawca dostaje kartę, nie historię rozmowy. Karta niejasna: pyta przed kodem, nie zgaduje.
4. **Granice ról.** Planista nie pisze kodu. Rola rozpisująca zadania nie zmienia zakresu i nie rozstrzyga spraw z rejestru. Wykonawca nie wychodzi poza kartę. Recenzent nie poprawia kodu w cudzym PR, poza literówkami i formatowaniem.
5. **Bramki ludzkie.** Akceptacja planu, scalenie, każda decyzja z rejestru i każda zmiana zakresu.
6. **Ryzyko decyduje o wykonawcy.** Zadania dotykające pieniędzy, danych osobowych, zapisów w systemach zewnętrznych, współbieżności i interfejsów między modułami dostaje mocniejszy wykonawca. W razie wątpliwości mocniejszy.
7. **Systemy zewnętrzne.** Zapisy tylko na obiektach testowych i tylko w zadaniach, które to wprost przewidują. Sekrety, dane osobowe i surowe odpowiedzi systemów nie trafiają do PR, raportów ani logu.

Limity domyślne (projekt może je zmienić w `CLAUDE.md`): plan najwyżej 15 zadań; karta najwyżej jeden ekran, zadanie najwyżej jeden dzień pracy; PR czytelny w jednej recenzji; najwyżej dwa cykle poprawek, trzeci to eskalacja do człowieka z opisem rozbieżności; odbiór etapu w jednym cyklu uwag, reszta jako zadania następnego etapu.

## 3. Szablony

Plan etapu:

```markdown
# Etap <nn>: <nazwa> (<data>)
Źródło: <dokumenty i sekcje, decyzje, sprawy z rejestru>
## Cel etapu
<2–3 zdania: co działa po etapie, czego nie>
## Zakres i poza zakresem
| W zakresie | Poza (dlaczego, gdzie trafia) |
## Zadania
| ID | Zadanie | Wejście (pliki, sekcje) | Kryterium akceptacji (dowód) | Zależy od | Rejestr | Wykonawca (propozycja) |
## Ryzyka etapu
| Ryzyko | Sygnał | Co robimy |
## Odbiór
<po etapie: kryteria ze statusem i dowodem; uwagi; zadania przeniesione>
```

Karta zadania:

```markdown
# <etap>-<id>: <nazwa>
Wykonawca: <kto> — <jedno zdanie dlaczego>
Gałąź: <nazwa>
## Cel
<jedno zdanie>
## Wejście
- <dokument i sekcja>; <sprawa z rejestru i założenie robocze>
## Wyjście
- pliki i moduły: …
- testy: <przypadki, które muszą istnieć>
- dokumenty do zaktualizowania: …
## Czego nie ruszać
- <inne moduły, systemy zewnętrzne poza obiektami testowymi, sprawy z rejestru>
## Kryterium akceptacji (dowód)
- <komenda testów, build, zrzut albo pomiar>
```

Opis PR:

```markdown
Zadanie: <etap>-<id> (<odesłanie do karty>)
Co zmienia w zachowaniu systemu: <2–4 zdania>
Jak sprawdzić: <komendy, adres na lokalnym środowisku, zrzuty>
Dowody: <wyniki testów, pomiary>
Dokumenty zaktualizowane: <pliki i sekcje> | brak (uzasadnienie)
Założenia z rejestru użyte w kodzie: <ID i miejsce>
Poza kartą (zgłoszone, niezrobione): <co i dlaczego wykracza>
```

Recenzja:

```markdown
Werdykt: akceptuję | poprawki (cykl 1/2) | eskalacja
Sprawdzone: <testy uruchomione i wynik; diff przeczytany w całości; zgodność z kartą i dokumentami>
Uwagi: <plik:linia — problem — oczekiwana zmiana>
Zakres: zgodny | wykracza (<ID>)
Dokumentacja: kompletna | brakuje <czego>
```

Wpis po scaleniu: `references/log-zdarzen.md`, sekcja 4.
