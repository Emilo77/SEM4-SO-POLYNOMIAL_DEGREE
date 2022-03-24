global polynomial_degree:

;Define macro
;Three arguments
;All_equal
;       equal <arr> <length> <result>

%macro equal 3
        mov eax, 0
        mov ecx, dword [%2]
        mov r12, 0
        lea rbx, [%1] ;może mov zamiast lea?

        %%checkLoop



;%endmacro

section .text

polynomial_degree:
