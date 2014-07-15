align 4
global vectortest_asm_2
vectortest_asm_2:	
	;;  double * a = rdi
	;;  double * b = rsi
	;;  unsigned int * ind = rdx
	;;  unsigned int N = rcx
	

	push rax
	xor rax,rax

	;vpcmpeqw ymm1,ymm1
	;vzeroall

loop:	sub rcx, 4
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;Slower than the one below
	;; vmovdqu xmm5,[rdx+4*rcx]

	;; vpextrw eax,xmm5,0
	;; vpextrw r8d,xmm5,2
	;; vpextrw r9d,xmm5,4
	;; vpextrw r10d,xmm5,6
	
	;; vmovq xmm1,[rsi+rax*8]
	;; vmovq xmm2,[rsi+r8*8]
	;; vmovq xmm3,[rsi+r9*8]
	;; vmovq xmm4,[rsi+r10*8]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; The fastest method
	;; For small arrays (<=1000) this is faster than gcc
	mov eax,[rdx+rcx*4]
	vmovq xmm1,[rsi+rax*8]
	mov eax,[rdx+rcx*4+4]
	vmovq xmm2,[rsi+rax*8]
	
	mov eax,[rdx+rcx*4+8]
	vmovq xmm3,[rsi+rax*8]
	mov eax,[rdx+rcx*4+12]	
	vmovq xmm4,[rsi+rax*8]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vmovlhps xmm1,xmm2
	vmovlhps xmm3,xmm4
	vinsertf128 ymm1,ymm1,xmm3,1

	;prefetcht0 [rdx+rcx*4+16]
	
	vaddpd ymm1, ymm1, [rdi+rcx*8]
	vmovupd [rdi+rcx*8], ymm1
	
	cmp rcx, 0
	jne loop

	pop rax
	
	ret
