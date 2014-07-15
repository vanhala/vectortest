align 4
global vectortest_asm_3
vectortest_asm_3:	
	;;  double * a = rdi
	;;  double * b = rsi
	;;  unsigned int * ind = rdx
	;;  unsigned int N = rcx
	
loop:	
	;; The slowest method (why is vgatherdpd so slow???)
	sub rcx, 4
	vmovdqu xmm2,[rdx+4*rcx]
	vpcmpeqw ymm3,ymm3	;set ymm3 to all ones, since it acts as the mask in vgatherdpd
	vgatherdpd ymm1,[rsi+8*xmm2],ymm3

	vaddpd ymm1, ymm1, [rdi+rcx*8]
	vmovupd [rdi+rcx*8], ymm1
	
	cmp rcx, 0
	jne loop
	
	ret
