;nasm -f elf64 qqnf.asm ; gcc -m64 -no-pie qqnf.o -o qqnf.x

extern printf
extern scanf
extern fopen
extern fclose
extern fprintf

%define readOnly  0o ; flag open()
%define writeOnly 1o ; flag open()
%define readwrite 2o ; flag open()
%define openrw  102o ; flag open()
%define userWR 644o  ; Read+Write+Execute
%define append 2101o ; flag open() criar/escrever no final

section .data
    sinc1  : db "%f %c %f",0
    sinc2  : db "%f %c %f = %f",10,0
	sinc3  : db "%f %c %f = Não implementado",10,0
	aux0 : dq 1
	fileName : db "Teste.txt", 0
	openApend : db "a+", 0
	aux1 : db 0
	
section .bss
	fileHandle : resq 10

section .text
    global main

add:
	push rbp

	mov rbp, rsp

	movss DWORD [rbp-4], xmm0
	movss DWORD [rbp-8], xmm1

	movss xmm0, DWORD [rbp-4]
	addss xmm0, DWORD [rbp-8]

	movss DWORD [rbp-4], xmm0
	movss xmm0, DWORD  [rbp-4]

	pop rbp

	ret

sub:
	push rbp

	mov rbp, rsp

	movss DWORD [rbp-4], xmm0
	movss DWORD [rbp-8], xmm1

	movss xmm0, DWORD  [rbp-4]
	subss xmm0, DWORD  [rbp-8]

	movss DWORD  [rbp-4], xmm0

	movss xmm0, DWORD  [rbp-4]

	pop rbp

	ret

mut:
	push rbp

	mov rbp, rsp

	movss DWORD [rbp-4], xmm0
	movss DWORD [rbp-8], xmm1

	movss xmm0, DWORD [rbp-4]
	mulss xmm0, DWORD [rbp-8]

	movss DWORD [rbp-4], xmm0

	movss xmm0, DWORD [rbp-4]

	pop rbp

	ret

divs:
	push rbp

	mov rbp, rsp

	movss DWORD [rbp-4], xmm0
	movss DWORD [rbp-8], xmm1

	movss xmm0, DWORD [rbp-4]
	divss xmm0, DWORD [rbp-8]

	movss DWORD [rbp-4], xmm0

	movss xmm0, DWORD [rbp-4]

	pop rbp

	ret

exp:
    push rbp
    mov rbp, rsp

    movss xmm2, xmm0
	cvttss2si rdi, xmm1
    cmp rdi, 0
    je i0
	jl im1
    cmp rdi, 1
    je i1
    jmp xini

i0:
    cvtsi2ss xmm0,[aux0]

i1:
    mov rsp, rbp
    pop rbp
	ret

xini:
    mulss xmm0, xmm2
    dec rdi
    cmp rdi, 1
    jne xini
	
	mov rsp, rbp
    pop rbp	
    ret
	jmp main
	
im1:
	xor r15b, r15b
	mov r15b, 1
	mov [aux1], r15b
	
	mov rsp, rbp
    pop rbp	
    ret


main:
	push rbp

	mov rbp, rsp
	
	sub rsp, 00100000b
	
	lea rdi, [fileName]
	lea rsi, [openApend] 
	
	call fopen 

	mov [fileHandle], rax
	

	lea rcx, [rbp-16]
	lea rdx, [rbp-17]
	lea rax, [rbp-12]

	mov rsi, rax
	mov edi, sinc1
	mov eax, 0

	call scanf

	movzx eax, BYTE [rbp-17]
	movsx eax, al

	cmp eax, 01110011b
	je T5

	cmp eax, 01101101b
	je T6

	cmp eax, 01100001b
	je T4

	cmp eax, 01100100b
	je T7

	cmp eax, 01100101b
	je T8
	jmp T9

T4:
	movss xmm0, DWORD [rbp-16]

	mov eax, DWORD [rbp-12]

	movaps xmm1, xmm0
	movd xmm0, eax

	call add

	movd eax, xmm0
	mov DWORD [rbp-4], eax
	mov BYTE [rbp-5], 43
	jmp T9

T5:
	movss xmm0, DWORD [rbp-16]

	mov eax, DWORD [rbp-12]

	movaps xmm1, xmm0
	movd xmm0, eax

	call sub

	movd eax, xmm0

	mov DWORD [rbp-4], eax
	mov BYTE [rbp-5], 00101101b
	jmp T9

T6:
	movss xmm0, DWORD [rbp-16]

	mov eax, DWORD [rbp-12]

	movaps xmm1, xmm0
	movd xmm0, eax

	call mut

	movd eax, xmm0

	mov DWORD [rbp-4], eax
	mov BYTE [rbp-5], 00101010b
	jmp T9

T7:
	movss xmm0, DWORD [rbp-16]

	mov eax, DWORD [rbp-12]

	movaps xmm1, xmm0
	movd xmm0, eax

	call divs

	movd eax, xmm0

	mov DWORD  [rbp-4], eax
	mov BYTE  [rbp-5], 00101111b
	jmp T9

T8:
	movss xmm0, DWORD [rbp-16]

	mov eax, DWORD [rbp-12]

	movaps xmm1, xmm0
	movd xmm0, eax

	call exp

	movd eax, xmm0

	mov DWORD  [rbp-4], eax
	mov BYTE  [rbp-5], 01011110b
	nop

T9:
	pxor xmm1, xmm1

	cvtss2sd xmm1, DWORD [rbp-4]

	movss xmm0, DWORD [rbp-16]

	cvtss2sd xmm0, xmm0

	movsx edx, BYTE [rbp-5]
	movss xmm2, DWORD [rbp-12]

	pxor xmm3, xmm3

	cvtss2sd xmm3, xmm2

	movq rax, xmm3

	movapd xmm2, xmm1
	movapd xmm1, xmm0

	mov esi, edx
	

	movq xmm0, rax
	
	xor r15b, r15b
	mov r15b, [aux1]
	cmp r15b, 0
	jne write2

write:
	mov rdi, [fileHandle]
	lea rsi, [sinc2]
	mov rax, 00000011b
	
	call fprintf
	
	mov eax, 0
	
	jmp fecha

write2:
	mov rdi, [fileHandle]
	lea rsi, [sinc3]
	mov rax, 00000100b
	
	call fprintf
	
	mov eax, 0

fecha:
	mov rdi, [fileHandle]

	call fclose
	
	leave
	ret

fim:
    mov rsp, rbp
    pop rbp

    mov rax, 60
    mov rdi, 0
    syscall