global polynomial_degree:

section .text

; Kamil Bugała (kb417522)
; SO gr. 6 (p. Michał Smolarek)

; OGÓLNA KONWENCJA:
; Liczby trzymamy w wielu segmentach na stosie (będę określał je jako bigNumy)
; Wykonujemy operacje :
; - przyrównywania wszystkich liczb do zera
; - odejmowania sąsiednich liczb ze sobą.
; Wykonujemy te dwie operacje tak długo, aż otrzymamy wyzerowaną tablicę
; lub nie pozostaną nam żadne liczby
; Ten proces to pseudo pochodna, dzięki której zbijamy asymptotykę wielomianu
; aż do otrzymania wielomianu stałego.

; OZNACZANIIE STAŁYCH (te rejestry nie będą modyfikowane):
; r10 - zarezerwowana ilość wszystkich bajtów na stosie
; r11 - ilość 8 bajtowych segmentów pojedynczego bigNuma
; (w komentarzach, jeżeli zapiszę segment bez rozmiaru, będzie on 8 bajtowy)

; OZNACZENIE GŁÓWNEJ ZMIENNEJ:
; r12 - aktualna ilość bigNumów
; oznaczenie zmiennych (główna zmienna w programie, wyznaczająca wynik)


; Opis: wstawienie "callee saved" rejestrów na stos,
;       aby potem przywrócić ich wartość
polynomial_degree:  ;
	push   r12
	push   r13
	push   r14
	push   r15

; Opis: wylicza ilość, jaką należy przeznaczyć na stos,
;       w zależności od wielkości danych początkowych, ustawia zmienne
; Rejestry w etykiecie:
; rax - chwilowa zmienna do obliczeń
; r8 - liczba segmentów pojedynczego bigNuma, zmniejszona o 1
; r11 - ustawienie ilości segmentów 8-bajtowych
; r12 - aktualna ilość bigNumów, na których wykonujemy operacje
; rsi - stała liczba bigNumów na początku
; rsp - wskaźnik na wierzch stos
; r10 - ilość bajtów zarezerwowanych na stosie
; r13 - ilość segmentów wszystkich używanych bigNumów
; r14, r15, rcx - countery
; r9 - rejestr wypełniony samymi zerami lub samymi jedynkami
counting_limits:
	mov    rax, rsi
	add    rax, 32  ; uwzględnienie najgorszego przypadku
	shr    rax, 6   ; dzielenie przez 64, otrzymanie podłogi z ilości segmentów
	inc    rax  ; otrzymanie sufitu, aby przy najgorszym przypadku dane się zmieściły
	mov    r11, rax  ; ilość segmentów potrzebna do reprezentacji bigNuma r11_max = 2^26
	mov    r12, rsi  ; aktualna ilość zmiennych na stosie
	mul    rsi    ; ilość wszystkich segmentów do operowania na liczbach na stosie
	shl    rax, 3   ; ilość wszystkich bajtów, o które należy przesunąć wskaźnik stosu
	mov    r10, rax
	sub    rsp, r10  ; zarezerwowanie miejsce na stos, trzymanie rozmiaru w rejestrze r10
	; liczba bajtów na stosie jest wielokrotnością 8, więc konwencja się zgadza

	mov    r8, r11
	dec    r8   ; ilość segmentów bigNuma, nie licząc pierwszego
	mov    rax, r11
	mul    rsi
	mov    r13, rax   ; ilość segmentów wszystkich bigNumów
	xor    r14, r14   ; wyzerowanie counterów
	xor    r15, r15
	xor    rcx, rcx   ; główny counter do iteracji po segmentach na stosie

; Opis: Kopiuje elementy z podanej nam pamięci rdi, zmienia wielkość na 8-bajtowe
;       ustawia je jako pierwsze segmenty bigNumów, wypełnia resztę segmentów
; Rejestry w etykiecie:
; rax - chwilowa zmienna do obliczeń
; r8 - liczba segmentów pojedynczego bigNuma, zmniejszona o 1
; r11 - ustawienie ilości segmentów 8-bajtowych
; rsp - wskaźnik na wierzch stosu
; r13 - ilość segmentów wszystkich używanych bigNumów
; r14, r15, rcx - countery
; r9 - rejestr wypełniony samymi zerami lub samymi jedynkami
put_elements_on_stack_loop: ; przenoszenie liczb z danej nam tablicy na stos
	movsxd  rax, dword [rdi + 4 * r15] ; wpisanie liczby 32-bitowej do 64-bit. segmentu
	mov    [rsp + 8 * rcx], rax ; wstawienie rozszerzonej liczby na stos
	inc    rcx

	inc    r15
	xor    r14, r14
	cmp    r11, 1  ; jeżeli bigNum ma tylko jeden segment, wypełniamy stos tylko podanymi liczbami
	je     .iter_end
.put_elements_on_stack_inner_loop:
	; wpp. wypełniamy resztę segmentów bigNuma, w zależności od znaku liczby
	xor    r9, r9	  ; jeżeli w 1. segmencie wpisaliśmy dodatnią, to resztę segmentów wypełniamy zerami
	cmp    rax, 0	  ; sprawdzamy znak
	jge    .fill
	not    r9	  ;	jeżeli jest ujemna, to wypełniamy jedynkami
.fill:		  ; wykonujemy to, aby reprezentacje binarne liczb się zgadzały
	mov    [rsp + 8 * rcx], r9  ; wypełniamy poboczne segmenty
	inc    rcx
	inc    r14
	cmp    r14, r8
	jl     .fill	 ; pętlimy się do momentu, aż wszystkie segmenty bigNuma zostaną wypełnione
.iter_end:
	cmp    rcx, r13	; jeżeli pozostały jakieś segmenty,
	; powtarzamy czynność dla następnego bigNuma
	jl     put_elements_on_stack_loop	; powtarzamy czynność,
	; aż wszystkie bigNumy zostaną umieszczone i wypełnione na stosie

; Główna pętla do operacji porównywania i obliczania różnicy bigNumów
main_loop:

; Opis: Sprawdza, czy wszystkie aktualne bigNumy są równe zero
;       (sprawdza, czy wszystkie ich segmenty są wyzerowane)
; Rejestry w etykiecie:
; rax - chwilowa zmienna do obliczeń
; r11 - ustawienie ilości segmentów 8-bajtowych
; r12 - ilość aktualnych bigNumów
; rsp - wskaźnik na wierzch stosu
; rcx - countery
check_all_zeros: ; sprawdzenie, czy wszystkie aktualne liczby są zerami
	mov    rax, r11
	mul    r12
	mov    rcx, rax ; ustawienie rcx na liczbę segmentów aktualnych bigNumów
.check_zero_loop:
	cmp    qword [rsp + 8 * (rcx - 1)], 0 ; porównanie każdego segmentu osobno
	jne    .not_equal_zero
	loop   .check_zero_loop ; wykonanie porównania dla każdego segmentu
.equal:
	jmp    set_value ; jeżeli wszystkie są równe, wychdzimy z głównej pętli
.not_equal_zero: ; jeśli nie wszystkie są równe 0, wykonujemy dalej różnice na bigNumach
	dec    r12
	cmp    r12, 0
	jne    substract
	jmp    set_value ; jeżeli nie pozostały nam żadne liczby,
	; kończymy z największym możliwym stopniem wielomianu

; Opis: Odejmuje sąsiednie bigNumy.
;       z [a, b, c, d, e] otrzymujemy [a - b, b - c, c - d, d - e]
; Rejestry w etykiecie:
; rax - chwilowa zmienna do obliczeń
; r8 - liczba segmentów pojedynczego bigNuma, zmniejszona o 1
; r9 - liczba bajtów pojedynczej liczby
; r11 - ustawienie ilości segmentów 8-bajtowych
; r12 - aktualna ilość bigNumów
; rcx, r13 - countery
; r14, r15 - wskaźniki do konkretnych segmentów na stosie
; rsp - wskaźnik na wierzch stosu
substract:  ; zmiana k liczb na k-1 liczb, będących różnicami sąsiednich liczb
	mov    rax, 8
	mul    r11
	mov    r9, rax  ; liczba bajtów pojedynczej liczby
	xor    rcx, rcx ; counter do wewnętrznych segmentów
	xor    r13, r13	; counter bigNumów
	mov    r14, rsp ; pointer na segment pierwszej liczby
	mov    r15, r14
	add    r15, r9  ; pointer na egment drugiej liczby
.first_segments:  ; zaczynamy od pierwszego, najmniej znaczącego segmentu liczby
	mov    rax, qword [r15 + rcx]
	sub    qword [r14 + rcx], rax
	pushf
.other_segments:  ; jeżeli liczba ma więcej niż 1 segment, dokonujemy tego na pozostałych
	add    rcx, 8
	cmp    rcx, r9
	je     .next_segment_sub
	mov    rax, qword [r15 + rcx]
	popf
	sbb    qword [r14 + rcx], rax   ; ważną rzeczą jest tutaj przeniesienie bitu
	; z poprzedniego segmentu, jeżeli wystąpiło przepełnienie
	pushf	; musimy także umieszczać flagi na stosie
	jmp    .other_segments ; ponieważ niektóre instrukcje nadpisałyby flagę
.next_segment_sub:  ; wykonujemy to dla pozostałych segmentów pojedynczego bigNuma
	popf
	inc    r13
	cmp    r13, r12
	jne    .next_bignum_sub
	jmp    main_loop ; jeżeli skończymy operacje na każdej parze liczb,
	; powtarzamy porówannie tablicy z zerami
.next_bignum_sub:
	add    r14, r9
	add    r15, r9
	xor    rcx, rcx
	jmp    .first_segments ; powtarzamy odejmowanie dla każdej pary sąsiednich liczb

; Opis: Wylicza minimalny stopień wielomianu na podstawie
;       poziomu, do którego doszliśmy
; Rejestry w etykiecie:
; rax - chwilowa zmienna do obliczeń
; rsi - stała ilość bigNumów na początku
; r12 - aktualna ilość bigNumów
set_value:
	mov    rax, rsi
	sub    rax, r12
	dec    rax

; Opis: Zapewnienie standardu ABI
;       Przywrócenie pierwotnego stanu stosu
;       Przywrócenie pierwotnych wartości "callee saved" rejestrów
;       Zwrócenie wyniku całej funkcji
finish:
	add    rsp, r10
	pop    r15
	pop    r14
	pop    r13
	pop    r12
	ret