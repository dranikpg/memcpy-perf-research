global test_loop
global test_movs
global test_loop_8s
global test_movs_8s
global test_opt

test_loop:
    enter 0, 0
    ; rdi - dst
    ; rsi - src
    ; rdx - c
    
    ; rax - tmp

.loop:
    cmp rdx, 0
    jle .end

    mov al, byte [rsi]
    mov [rdi], al

    dec rdx
    inc rdi
    inc rsi
    jmp .loop
.end:
    leave
    ret

test_movs:
    enter 0, 0
    ; rdi - dst
    ; rsi - src
    ; rdx - c

    ; store rcx
    mov rax, rcx
    
    mov ecx, edx
    mov rcx, rdx
    rep movsb

    ; restore rcx
    mov rcx, rax

    leave
    ret

test_loop_8s:
    enter 0, 0
    ; rdi - dst
    ; rsi - src
    ; rdx - c

    ; write whole eight
.loop_1:
    sub rdx, 8
    cmp rdx, 0
    jl .end_loop_1

    mov rax, [rsi]
    mov [rdi], rax

    add rsi, 8
    add rdi, 8

    jmp .loop_1
.end_loop_1:
    ; exit on zero
    cmp rdx, 0
    je .end
    add rdx, 8
    ; write rest
.loop_2:
    cmp rdx, 0
    jle .end
    
    mov al, byte [rsi]
    mov [rdi], al

    dec rdx
    inc rdi
    inc rsi
    jmp .loop_2
.end:
    leave
    ret

test_movs_8s:
    enter 0, 0
    ; rdi - dst
    ; rsi - src
    ; rdx - c

    ;and rax, 7

    ; handle <8
.loop_1:
    mov rax, rdx
    and rax, 7
    cmp rax, 0
    jle .end_loop_1

    mov al, byte [rsi]
    mov [rdi], al

    dec rdx
    inc rdi
    inc rsi
    jmp .loop_1
.end_loop_1:
    ; check zero, calc new count
    cmp rdx, 0
    je .end
    shr rdx, 3

    ; store rcx
    mov rax, rcx
    
    mov ecx, edx
    mov rcx, rdx
    rep movsq

    ; restore rcx
    mov rcx, rax
.end:
    leave
    ret

test_opt:
    ; rdi - dst
    ; rsi - src
    ; rdx - c
    cmp rdx, 8
    jl .small

    cmp rdx, 256
    jge .call_movs_8s
.call_loop_8s:
    jmp test_loop_8s
    jmp .end
.call_movs_8s:
    jmp test_movs_8s
    jmp .end

.small:
    enter 0, 0

    test    rdx, 4
    je      .L2
    mov     eax, DWORD [rsi]
    add     rdi, 4
    add     rsi, 4
    mov     DWORD [rdi-4], eax
.L2:
    test    rdx, 2
    je      .L3
    movzx   eax, WORD [rsi]
    add     rdi, 2
    add     rsi, 2
    mov     WORD [rdi-2], ax
.L3:
    and     rdx, 1
    je      .L1
    movzx   eax, BYTE [rsi]
    mov     BYTE [rdi], al
.L1:
    leave
.end:
    ret
