global polynomial_degree:

;Define macro
;Three arguments
;All_equal
;       equal <arr> <length> <result>

;%endmacro

; ZMIENNE
; ilość segmentów na pojedynczy bigNum
; ilość wszystkich segmentów do trzymania wszystkich bigNumów (alokacja na stosie)
; iterator do chodzenia po całych bigNumach
; iterator do chodzenia wewnątrz pojedynczego bigNuma

section .text

polynomial_degree:
    mov rax, rsi
    add rax, 32  ; najgorszy przypadek to 2^32, -2^32, 2^32, ...
    shr rax, 6 ; dzielenie przez 64, otrzymanie podłogi z ilości segmentów
    inc rax
    mov r11, rax ; r11 - ilość segmentów potrzebna do reprezentacji bignuma r11_max = 2^26

    mul rsi
;    dec rax ; odjęcie 1, bo będzie co najwyżej n-1 bignumów, ODKOMENTOWAĆ JEŚLI ZADZIAŁA
    mov r12, rax ; r12 - ilość wszystkich segmentów do iteracji, r12_max = 2^58

    mov r14, rsi ; r14 - iterator zewnętrzny do chodzenia po bignumach
    mov r15, r11 ; r15 - iterator wewnętrzny do chodzenia po segmnetach wewnątrz bignuma


    shl rax, 3 ; ilość wszystkich bitów, o które należy przesunąć wskaźnik stosu, 8 * r12
    mov r10, rax
    sub rsp, rax
    add rsp, rax
    ret
;push_stack_loop:
;    push ... ;pushowanie czegoś
;    loop push_stack_loop













; sprawdzenie, czy wszystkie są równe (i równe 0)
; odejmowanie bigNumów, wstawienie na odpowiednie miejsca
; w loopie robić x razy push na stosie

