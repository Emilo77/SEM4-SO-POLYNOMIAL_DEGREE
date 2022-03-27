global polynomial_degree:

%define BIGNUMS_COUNT rsi
%define SEGMENTS_COUNT r11
%define actual_count r12
%define STACK_DATA r10

section .text

polynomial_degree:
    push r12
    push r14
    push r15

    mov rax, BIGNUMS_COUNT
    add rax, 32  ; najgorszy przypadek to 2^32, -2^32, 2^32, ...
    shr rax, 6 ; dzielenie przez 64, otrzymanie podłogi z ilości segmentów
    inc rax
    mov SEGMENTS_COUNT, rax ; r11 - ilość segmentów potrzebna do reprezentacji bignuma r11_max = 2^26
    mov actual_count, BIGNUMS_COUNT ; r12 - aktualna ilość zmiennych na stosie
    mul BIGNUMS_COUNT

    shl rax, 3 ; ilość wszystkich bitów, o które należy przesunąć wskaźnik stosu
    mov STACK_DATA, rax ; r10 - zarezerwowane miejsce na stos
    sub rsp, STACK_DATA

    xor r14, r14 ; ustawienie countera bigNumów
loop_conv_32:
    mov rcx, SEGMENTS_COUNT ; counter do chodzenia po wewnętrznych segmentach pojedynczego bigNuma
    dec rcx

    mov rax, r14 ;
    mul SEGMENTS_COUNT ; ilość segmentów dla jednego bigNuma
    mov r15, rax ; ustawienie r15 na pierwszy segment kolejnych bigNumów

    movsxd rax, dword [rdi + 4 * r14]
    mov [rsp + 8 * r15], rax; wstawienie

    cmp rcx, 0
    je next_bignum

    xor r8, r8 ; wyzerowanie rejestru r8
    cmp rax, 0
    jge fill_segments
    not r8 ; wypełnienie rejestru r8 jedynkami (jeśli rax będzie ujemny)

fill_segments:
    mov rax, r15
    add rax, rcx
    mov [rsp + 8 * rax], r8
    loop fill_segments

next_bignum:
    inc r14
    cmp r14, actual_count
    jne loop_conv_32

check_all_zeros:
    mov rax, SEGMENTS_COUNT
    mul actual_count
    mov rcx, rax ; ustawienie countera na ilość wszystkich segmentów

check_zero_loop:
    cmp qword [rsp + 8 * (rcx - 1)], 0 ; sprawdzenie każdego segmentu, czy jest równy 0
    jne not_zero
    loop check_zero_loop
    jmp  set_value

not_zero: ; jeżeli jakikolwiek segment jest różny od zera, przechodzimy poziom niżej
    dec actual_count
    cmp actual_count, 0
    je set_value

xor rcx, rcx ; wyzerowanie countera do chodzenia po segmentach zewnętrznych
sub_all_bignums:
    xor r14, r14 ; wyzerowanie countera do chodzenia po wewnętrznych segmentach

    mov rax, rcx
    mul SEGMENTS_COUNT
    dec rax
sub_single_bignums:
    inc rax
    add rax, SEGMENTS_COUNT
    mov r15, [rsp + 8 * rax]
    sub rax, SEGMENTS_COUNT

    cmp r14, 0
    jne other_sub

first_sub:
    sub qword [rsp + 8 * rax], r15
    pushf
    jmp sub_single_end

other_sub:
    popf
    sbb qword [rsp + 8 * rax], r15
    pushf

sub_single_end:
    inc r14
    cmp r14, SEGMENTS_COUNT
    jne sub_single_bignums
    popf
    inc rcx
    cmp rcx, actual_count
    jne sub_all_bignums
    jmp check_all_zeros

set_value:
    mov rax, BIGNUMS_COUNT
    sub rax, actual_count
    dec rax

finish:
    add rsp, r10
    pop r15
    pop r14
    pop r12
    ret