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
    mov r12, qword rdi ;rdi - ilość wszystkich bignumów
    div r12, 64
    inc r12 ;ilość segmentów potrzebna do reprezentacji bignuma

    mov rcx, r12
    mul rcx, rdi ;ustawienie countera na ilość wszystkich segmentów

push_stack_loop:
    push ... ;pushowanie czegoś
    loop push_stack_loop








; sprawdzenie, czy wszystkie są równe (i równe 0)
; odejmowanie bigNumów, wstawienie na odpowiednie miejsca
; w loopie robić x razy push na stosie

