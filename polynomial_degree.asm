global polynomial_degree:

%define SEGMENTS_COUNT r11
%define BIGNUMS_COUNT rsi
%define actual_count r12

section .text

polynomial_degree:
    push r12
    push r13
    push r14
    push r15

    mov rax, BIGNUMS_COUNT
    add rax, 32  ; najgorszy przypadek to 2^32, -2^32, 2^32, ...
    shr rax, 6 ; dzielenie przez 64, otrzymanie podłogi z ilości segmentów
    inc rax
    mov r11, rax ; r11 - ilość segmentów potrzebna do reprezentacji bignuma r11_max = 2^26
    mov actual_count, BIGNUMS_COUNT ; r12 - aktualna ilość zmiennych na stosie

    mul rsi
;    dec rax ; odjęcie 1, bo będzie co najwyżej n-1 bignumów, ODKOMENTOWAĆ JEŚLI ZADZIAŁA

    shl rax, 3 ; ilość wszystkich bitów, o które należy przesunąć wskaźnik stosu
    mov r10, rax ; r10 - zarezerwowane miejsce na stos
    sub rsp, rax

loop_conv_32:
    mov rcx, r11 ; counter do chodzenia po wewnętrznych segmentach pojedynczego bigNuma
    dec rcx

    mov rax, r14 ;
    mul SEGMENTS_COUNT ; ilość segmentów dla jednego bigNuma
    mov r13, rax ; ustawienie r13 na iloczyn r14 i r15

    movsxd rax, dword [rdi + 4 * r14]
    mov [rsp + 8 * r13], rax; wstawienie

    cmp rcx, 0
    je next_bignum
    xor r8, r8 ; wyzerowanie rejestru r8
    cmp rax, 0
    jge fill
    not r8 ; wypełnienie rejestru r8 jedynkami (jeśli rax będzie ujemny)
fill:
    mov r9, r13
    add r9, rcx
    mov [rsp + 8 * r9], r8
    loop fill
next_bignum:
    inc r14
    cmp r14, BIGNUMS_COUNT
    jne loop_conv_32

main_loop:


check_all_zeros:
    mov rax, SEGMENTS_COUNT
    mul actual_count
    mov rcx, rax
check_zero_loop:
    cmp qword [rsp + (rcx - 1)], 0
    jne not_equal_zero
    loop check_zero_loop
equal:
    jmp set_value
not_equal_zero:
    dec actual_count
    cmp actual_count, 0
    jne substract
    jmp set_value


substract:
    mov rax, actual_count
    inc rax
    mul SEGMENTS_COUNT
    mov rcx, rax
    xor r13, r13
    xor r14, r14
    xor r15, r15
    add r15, SEGMENTS_COUNT

    cmp SEGMENTS_COUNT, 1
;    je without_carry_loop
    jmp with_carry_loop

without_carry_loop:
    mov r9, [rsp + 8 * r15]
    sub [rsp + 8 * r14], r9
    inc r14
    inc r15
    cmp r14, rcx
    jne without_carry_loop
    jmp main_loop


with_carry_loop:

first_segments:
    mov r13, SEGMENTS_COUNT
    dec r13
    mov rax, qword [rsp + 8 * r15]
    sub qword [rsp + 8 * r14], rax
    inc r14
    inc r15

other_segments:
    mov rax, qword [rsp + 8 * r15]
    sbb qword [rsp + 8 * r14], rax
    inc r14
    inc r15
    dec r13
    jz other_segments
    cmp r14, rcx
    jl first_segments
    jmp main_loop


set_value:
    mov rax, BIGNUMS_COUNT
    sub rax, actual_count
    dec rax

finish:
    add rsp, r10
    pop r15
    pop r14
    pop r13
    pop r12
    ret
; odejmowanie bigNumów, wstawienie na odpowiednie miejsca