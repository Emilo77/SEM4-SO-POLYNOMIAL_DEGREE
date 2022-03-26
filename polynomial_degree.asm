global polynomial_degree:

;Define macro
;Three arguments
;All_equal
;       equal <arr> <length> <result>
;

;%macro fill     3
;    xor rbx, rbx
;    cmp [%1], 0
;    je %%start:
;    not rbx
;    jmp %%start:
;
;%%start:


;%endmacro

; ZMIENNE
; ilość segmentów na pojedynczy bigNum
; ilość wszystkich segmentów do trzymania wszystkich bigNumów (alokacja na stosie)
; iterator do chodzenia po całych bigNumach
; iterator do chodzenia wewnątrz pojedynczego bigNuma

section .text


polynomial_degree:
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15

    mov rax, rsi
    add rax, 32  ; najgorszy przypadek to 2^32, -2^32, 2^32, ...
    shr rax, 6 ; dzielenie przez 64, otrzymanie podłogi z ilości segmentów
    inc rax
    mov r11, rax ; r11 - ilość segmentów potrzebna do reprezentacji bignuma r11_max = 2^26
    mov r12, rsi ; r12 - aktualna ilość zmiennych na stosie
    dec r12 ; r12 = n - 1

    mul rsi
;    dec rax ; odjęcie 1, bo będzie co najwyżej n-1 bignumów, ODKOMENTOWAĆ JEŚLI ZADZIAŁA

    mov r14, rsi ; r14 - iterator zewnętrzny do chodzenia po bignumach
    mov r15, r11 ; r15 - iterator wewnętrzny do chodzenia po segmnetach wewnątrz bignuma


    shl rax, 3 ; ilość wszystkich bitów, o które należy przesunąć wskaźnik stosu
    mov r10, rax ; r10 - zarezerwowane miejsce na stos
    sub rsp, rax


    cmp rsi, 1 ; rsi = n
    je check_zero

    mov rcx, 0 ; counter od 1 do n - 1
    mov r9, rsi
    dec r9

check_equal:
    mov eax, dword [rdi + 4 * rcx]
    cmp eax, dword [rdi + 4 * (rcx + 1)]
    jne not_equal
    inc rcx
    cmp rcx, r9
    je check_zero
    jmp check_equal


check_zero:
    mov edx, dword [rdi]
    mov eax, -1
    cmp edx, 0
    je finish
    mov eax, 0
    jmp finish

not_equal:
    mov r9, rsi
    mov r14, 0 ; ustawienie countera bigNumów

loop_conv_32:
    mov rcx, r11 ; counter do chodzenia po wewnętrznych segmentach pojedynczego bigNuma
    dec rcx

    mov rax, r14 ;
    mul r11 ; ilość segmentów dla jednego bigNuma
    mov r13, rax ; ustawienie r13 na iloczyn r14 i r15

    movsxd rax, dword [rdi + 4 * r14]
    mov [rsp + 8 * r13], rax; wstawienie

    cmp rcx, 0
    je next_bignum:

    xor r8, r8 ; wyzerowanie rejestru r8
    cmp rax, 0
    jge .fill
    not r8 ; wypełnienie rejestru r8 jedynkami (jeśli rax będzie ujemny)

    .fill:
        mov rbx, r13
        add rbx, rcx
        mov [rsp + 8 * rbx], r8
        loop fill

next_bignum:
    inc r14
    cmp r14, rsi
    jne loop_conv_32

main_loop:

substract:



    xor r14, r14 ; wyzerowanie countera do iteracji po wewnętrznych segmentach pojedynczego bigNuma
check_equal_all:

check_equal_segment:
    mov rcx, r12 ; zapisanie w counterze ilości liczb do porównania


;    mov rax, 0 ; [rsp + ...]
;    cmp rax, 0 ; [rsp + ... + przeskok]
    je next:
    jne equal_break:

equal_break:
    dec r12
    cmp r12, 1
    je set_value
    jmp main_loop

next:
    inc rcx
    cmp rcx, rsi ; jeżeli counter dojdzie do liczby bigNumów, robimy kolejną iterację
    jne check_equal_segment:






set_value:
    mov rax, rsi
    sub rax, r12
finish:
    add rsp, r10
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret

; sprawdzenie, czy wszystkie są równe (i równe 0)
; odejmowanie bigNumów, wstawienie na odpowiednie miejsca
; w loopie robić x razy push na stosie

