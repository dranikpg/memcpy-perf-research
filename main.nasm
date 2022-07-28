global test_loop
global test_loopq
global test_repstosb
global test_repstosq

test_loop:
    ; rdi - dst
    ; rsi - byte
    ; rdx - count
    enter 0, 0
    mov rax, rsi
.start:
    cmp rdx, 0
    je .end

    mov BYTE [rdi], al
    inc rdi
    dec rdx

    jmp .start
.end:

    leave
    ret

test_loopq:
    ; rdi - dst
    ; rsi - byte
    ; rdx - count
    enter 0, 0
    mov rax, rsi

    ; do single loop
.start_small:
    test rdx, 7
    jz .end_small

    mov BYTE [rdi], al
    inc rdi
    dec rdx

    jmp .start_small
.end_small:
    shr rdx, 3
    
    ; extend rax
    shr rsi, 8
    or rax, rsi
    shr rsi, 8
    or rax, rsi
    shr rsi, 8
    or rax, rsi

    ; do 8 loop
.start:
    cmp rdx, 0
    je .end

    mov QWORD [rdi], rax
    inc rdi
    dec rdx

    jmp .start
.end:

    leave
    ret

test_repstosb:
    enter 0, 0

    ; rdi - dst
    ; rsi - byte
    ; rdx - count

    mov rax, rsi
    mov r8, rcx
    mov rcx, rdx

    rep stosb

    mov rcx, r8

    leave
    ret

test_repstosq:
    enter 0, 0

    mov rax, rsi
    mov r8, rcx

    mov rcx, rdx
    and rcx, 7
    rep stosb

    mov rcx, rdx
    shr rcx, 3
    rep stosq

    mov rcx, r8

    leave
    ret