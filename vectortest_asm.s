align 4
global vectortest_asm
vectortest_asm:	
	;;  double * a = rdi
	;;  double * b = rsi
	;;  unsigned int * ind = rdx
	;;  unsigned int N = rcx

	push rax
	xor rax,rax

loop:	sub rcx, 1
	mov eax, [rdx+rcx*4]	;eax = ind[rcx]
	vmovq xmm0, [rdi+rcx*8] 	;xmm0 = a[rcx]
	vaddsd xmm0, [rsi+rax*8]	;xmm1 += b[rax] ( and b[rax] = b[eax] = b[ind[rcx]])
	vmovq [rdi+rcx*8], xmm0
	cmp rcx, 0
	jne loop

	pop rax
	
	ret
