section .rodata
val_rbp	dq 0x1111122222333334
val_rbx	dq 0x2222233333444445
val_r12	dq 0x3333344444555556
val_r13	dq 0x4444455555666667
val_r14	dq 0x5555566666777778
val_r15	dq 0x6666677777888889

section .text

global _start
extern polynomial_degree

_start:
    ; te rejestry mają się nie zmienić
    mov		rbp, [val_rbp]
    mov		rbx, [val_rbx]
    mov		r12, [val_r12]
    mov		r13, [val_r13]
    mov		r14, [val_r14]
    mov		r15, [val_r15]

    ; inicjalizuję argumenty 
    mov		rsi, 5
    sub		rsp, 20
    mov		dword [rsp], 2
    mov		dword [rsp + 4], 5
    mov		dword [rsp + 8], 10
    mov		dword [rsp + 12], 17
    mov		dword [rsp + 16], 26
    mov		rdi, rsp

    ; rsp przy wejściu do _start ma gwarantowane, że jest 16-byte aligned
    ; dodałem 20 bajtów na stos
    ; więc jeszcze dodaję 4 byte'y, aby był align 16k+8 przy wejściu do funkcji
    sub		rsp, 4

    ; teraz rsp jest ma dobrą resztę mod 16, więc mogę wywołać funkcję spełniającą ABI
    call polynomial_degree

    ; sprawdzam wynik
    cmp		eax, 2
    jne		fail

    ; sprawdzam, czy tablica się nie zmieniła
    add		rsp, 4
    cmp		dword [rsp], 2
    jne		fail
    cmp		dword [rsp + 4], 5
    jne		fail
    cmp		dword [rsp + 8], 10
    jne		fail
    cmp		dword [rsp + 12], 17
    jne		fail
    cmp		dword [rsp + 16], 26
    jne		fail

    ; sprawdzam, czy odpowiednie rejestry się nie zmieniły
    cmp		rbp, [val_rbp]
    jne		fail
    cmp		rbx, [val_rbx]
    jne		fail
    cmp		r12, [val_r12]
    jne		fail
    cmp		r13, [val_r13]
    jne		fail
    cmp		r14, [val_r14]
    jne		fail
    cmp		r15, [val_r15]
    jne		fail

    ; sprawdzam, czy DF(direction flag) jest ustawiona na 0
    pushf
    pop  rax
    bt   rax, 10

success:
    mov		rax, 60
    mov		rdi, 0
    syscall

fail:
    mov		rax, 60
    mov		rdi, 1
    syscall
