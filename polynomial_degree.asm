global polynomial_degree

%define BIGNUMS_COUNT rsi
%define SEGMENTS_COUNT r11
%define actual_count r12
%define STACK_DATA r10

section .text

polynomial_degree:
    push r12
    push r13
    push r14
    push r15

    mov rax, BIGNUMS_COUNT
    add rax, 32                         ; najgorszy przypadek to 2^32, -2^32, 2^32, ...
    shr rax, 6                          ; dzielenie przez 64, otrzymanie podłogi z ilości segmentów
    inc rax
    mov SEGMENTS_COUNT, rax             ; r11 - ilość segmentów potrzebna do reprezentacji bignuma r11_max = 2^26
    mov actual_count, BIGNUMS_COUNT     ; r12 - aktualna ilość zmiennych na stosie
    mul BIGNUMS_COUNT

    shl rax, 3                          ; ilość wszystkich bitów, o które należy przesunąć wskaźnik stosu
    mov STACK_DATA, rax                 ; r10 - zarezerwowane miejsce na stos
    sub rsp, STACK_DATA


    xor rcx, rcx                        ; counter do wszystkich segmentów na stosie
    xor r15, r15
    mov r8, SEGMENTS_COUNT
    dec r8
    mov rax, SEGMENTS_COUNT
    mul BIGNUMS_COUNT
    mov r13, rax
put_elements_on_stack_loop:             ; przenoszenie intów z danej nam tablicy na stos
    movsxd rax, dword [rdi + 4 * r15]   ; zapisanie intów do segmentów 8-bajtowych
    mov [rsp + 8 * rcx], rax            ; zapisanie pierwszych segmentów bigNumów na miejsca na stosie
    inc rcx

    inc r15
    xor r14, r14
put_elements_on_stack_inner_loop:
    xor r9, r9                          ;
    cmp rax, 0
    jge fill
    not r9
fill:
    mov [rsp + 8 * rcx], r9
    inc rcx
    inc r14
    cmp r14, r8
    jl fill
    cmp rcx, r13
    jl put_elements_on_stack_loop

main_loop:

    mov rax, actual_count
    mul SEGMENTS_COUNT
    mov rcx, rax
check_if_all_zeros:
    cmp qword [rsp + 8 * (rcx - 1)], 0
    jne not_equal
    loop check_if_all_zeros
equal:
    jmp set_final_value
not_equal:
    dec actual_count
    cmp actual_count, 0
    jne substract_all
    jmp set_final_value

substract_all:
    mov rcx, SEGMENTS_COUNT


;substract_all:
;
;    xor rcx, rcx
;    xor r14, r14
;    xor r15, r15
;
;    substract_outer_loop:
;    xor r14, r14
;    substract_inner_loop:
;        add rcx, SEGMENTS_COUNT
;        mov r9, [rsp + 8 * rcx]
;        sub rcx, SEGMENTS_COUNT
;
;        cmp r14, 0
;        jne other_segment
;
;        first_segment:
;            sub [rsp + 8 * rcx], r9
;            pushf
;            inc rcx
;            jmp next_iter
;
;        other_segment:
;             popf
;             sbb [rsp + 8 * rcx], r9
;             pushf
;             inc rcx
;
;        next_iter:
;            inc r14
;            cmp r14, SEGMENTS_COUNT
;            jne substract_inner_loop
;            popf
;            inc r15
;            cmp r15, actual_count
;            jne substract_outer_loop
;            jmp main_loop



;    substract_bignums_loop:
;
;        xor r14, r14
;    substract_bignums_inner_loop:
;        add rcx, SEGMENTS_COUNT
;        mov r8, [rsp + 8 * rcx]
;        sub rcx, SEGMENTS_COUNT
;
;        cmp r14, 0
;        je first_segment
;
;    first_segment:
;        sub [rsp + 8 * rcx], r8
;        pushf
;        jmp step
;
;    other_segment:
;        popf
;        sbb [rsp + 8 * rcx], r8
;        pushf
;
;    step:
;        inc rcx
;        inc r14
;        cmp r14, SEGMENTS_COUNT
;        je substract_bignums_inner_loop
;        popf
;        inc r15
;        cmp r15, actual_count
;        jne substract_bignums_loop
;        jmp end_of_function

set_final_value:
    mov rax, BIGNUMS_COUNT
    sub rax, actual_count
    dec rax

end_of_function:
    add rsp, STACK_DATA
    pop r15
    pop r14
    pop r13
    pop r12
    ret


