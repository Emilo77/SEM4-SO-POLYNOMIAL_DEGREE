global polynomial_degree:

section .data

SYS_EXIT equ 60

%define BIGNUMS_COUNT rsi
%define SEGMENTS_COUNT r11
%define actual_count r12

section .text

; Ogólna konwencja:
; Liczby trzymamy w wielu segmentach na stosie (będę określał je jako bigNumy)
; Wykonujemy operacje :
; - przyrównywania wszystkich liczb do zera
; - odejmowania sąsiednich liczb ze sobą.
; Wykonujemy te dwie operacje tak długo, aż otrzymamy wyzerowaną tablicę
; lub nie pozostaną nam żadne liczby
; Ten proces to pseudo pochodna, dzięki której zbijamy asymptotykę wielomianu
; aż do otrzymania wielomianu stałego.

polynomial_degree:                    ; wstawienie "callee saved" rejestrów na stos
	push   r12                         	; aby potem przywrócić ich wartość
	push   r13
	push   r14
	push   r15

counting_limits:
	mov    rax, BIGNUMS_COUNT
	add    rax, 32                    	; uwzględnienie najgorszego przypadku
	shr    rax, 6                      	; dzielenie przez 64, otrzymanie podłogi z ilości segmentów
	inc    rax
	mov    r11, rax                   	; r11 - ilość segmentów potrzebna do reprezentacji bigNuma r11_max = 2^26
	mov    actual_count, BIGNUMS_COUNT 	; r12 - aktualna ilość zmiennych na stosie
	mul    rsi
	shl    rax, 3                     	; ilość wszystkich bitów, o które należy przesunąć wskaźnik stosu
	mov    r10, rax
	sub    rsp, rax                  		; zarezerwowanie miejsce na stos, trzymanie miejsca w rejestrze r10

	mov 	 r8, SEGMENTS_COUNT
	dec 	 r8
	mov 	 rax, SEGMENTS_COUNT
	mul 	 BIGNUMS_COUNT
	mov 	 r13, rax
	xor    r14, r14
	xor		 r15, r15
	xor    rcx, rcx
put_elements_on_stack_loop:          	; przenoszenie intów z danej nam tablicy na stos
	movsxd rax, dword [rdi + 4 * r15]   ; zapisanie intów do segmentów 8-bajtowych
	mov 	 [rsp + 8 * rcx], rax       	; zapisanie pierwszych segmentów bigNumów na miejsca na stosie
	inc 	 rcx

	inc 	 r15
	xor 	 r14, r14
	cmp 	 SEGMENTS_COUNT, 1
	je 		 iter_end
put_elements_on_stack_inner_loop:
	xor 	 r9, r9
	cmp 	 rax, 0
	jge 	 fill
	not 	 r9
fill:
	mov 	 [rsp + 8 * rcx], r9
	inc 	 rcx
	inc 	 r14
	cmp 	 r14, r8
	jl 	 	 fill
iter_end:
	cmp 	 rcx, r13
	jl 		 put_elements_on_stack_loop

main_loop:

check_all_zeros:                     	; sprawdzenie, czy wszystkie aktualne liczby są zerami
	mov		 rax, SEGMENTS_COUNT
	mul    actual_count
	mov    rcx, rax                    	; ustawienie rejestru rcx na liczbę wszystkich segmentów na stosie
.check_zero_loop:
	cmp    qword [rsp + 8 * (rcx - 1)], 0
	jne    .not_equal_zero
	loop   .check_zero_loop           	; wykonanie porównania dla każdego segmentu
.equal:
	jmp    set_value               			; jeżeli wszystkie są równe, wychdzimy z głównej pętli
.not_equal_zero:                  		; jeżeli nie wszystkie liczby będą równe 0, wykonujemy różnice na licbach
	dec    actual_count
	cmp    actual_count, 0
	jne    substract
	jmp    set_value                 		; jeżeli nie pozostały nam żadne liczby, kończymy z największym możliwym stopniem wielomianu

substract:                           	; zmiana k liczb na k-1 liczb, będących różnicami sąsiednich liczb
	mov    rax, 8                      	; z [a, b, c, d, e] otrzymujemy [a - b, b - c, c - d, d - e]
	mul    SEGMENTS_COUNT
	mov    r9, rax                     	; liczba bajtów pojedynczej liczby
	xor    rcx, rcx                    	; counter do wewnętrznych segmentów
	xor    r13, r13                    	; counter bigNumów
	mov    r14, rsp                     ; pointer na pierwszą liczbę
	mov    r15, r14
	add    r15, r9                     	; pointer na następną liczbę
.first_segments:                      ; zaczynamy od pierwszego, najmniej znaczącego segmentu liczby
	mov    rax, qword [r15 + rcx]
	sub    qword [r14 + rcx], rax
	pushf
.other_segments:                    	; jeżeli liczba ma więcej niż 1 segment, dokonujemy tego na pozostałych
	add    rcx, 8
	cmp    rcx, r9
	je     .next_segment_sub
	mov    rax, qword [r15 + rcx]
	popf
	sbb    qword [r14 + rcx], rax     	; ważną rzeczą jest tutaj przeniesienie bitu z poprzedniego segmentu, jeżeli wystąpiło przepełnienie
	pushf																; musimy także umieszczać flagi na stosie
	jmp    .other_segments             	; ponieważ niektóre instrukcje nadpisałyby flagę
.next_segment_sub:										; wykonujemy to dla pozostałych segmentów pojedynczej liczby
	popf
	inc    r13
	cmp    r13, actual_count
	jne    .next_bignum_sub
	jmp    main_loop                  	; jeżeli skończymy operacje na każdej parze liczb, powtarzamy porówannie tablicy z zerami
.next_bignum_sub:
	add    r14, r9
	add    r15, r9
	xor    rcx, rcx
	jmp    .first_segments           		; powtarzamy odejmowanie dla każdej pary sąsiednich liczb

set_value:                          	; na podstawie otrzymanego poziomu, obliczamy minimalny stopień
	mov    rax, BIGNUMS_COUNT
	sub    rax, actual_count
	dec    rax

finish:                             	; zapewnienie ABI oraz zwrócenie wyniku
	add    rsp, r10
	pop    r15
	pop    r14
	pop    r13
	pop    r12
	ret

syscall