global polynomial_degree:

;Define macro
;Three arguments
;All_equal
;       equal <arr> <length> <result>


; ZMIENNE
; ilość segmentów na pojedynczy bigNum
; ilość wszystkich segmentów do trzymania wszystkich bigNumów (alokacja na stosie)
; iterator do chodzenia po całych bigNumach
; iterator do chodzenia wewnątrz pojedynczego bigNuma
;

;%endmacro

section .text

polynomial_degree:
    mov r12, qword rdi ;rdi - ilość wszystkich bignumów
    div r12, 64
    inc r12 ;ilość segmentów potrzebna do reprezentacji bignuma

; sprawdzenie, czy wszystkie są równe (i równe 0)
; odejmowanie bigNumów, wstawienie na odpowiednie miejsca

