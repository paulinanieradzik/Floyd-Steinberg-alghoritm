OPTION CASEMAP:NONE

.NOLIST
.NOCREF
.LIST

.data 
my255 DD 0437f0000r                        ; 255
.code
AlghoritmCalculator proc ;RCX byte array RDX number of bits R8 width R9 height


push rbp
push rdi
push rsi
push rbx
push r10
push r11
push r12
push r13
push r14
push r15
	mov r15, RDX			;number of bits in picture
	;mov r14, RDX			;number of bits in picture
	mov r13, R8				;picture width
	mov r12, R9				;mo¿e byæ xor bo jedno height wt=ystarczy?
	xor r11, r11			;byte array counter
	xor r10, r10


	xorps xmm0,xmm0			;oldB
	xorps xmm1,xmm1			;oldG
	xorps xmm2,xmm2			;oldR
	xorps xmm3,xmm3			;numberOfBits
	xorps xmm4, xmm4		;newB
	xorps xmm5, xmm5		;newG
	xorps xmm6, xmm6		;newR
	xorps xmm7, xmm7
	cvtsi2ss xmm3, r15
	mov rax, 255
	cdq
	idiv r15
	mov r12, rax
	
	sub r9, 1

	xor r14, r14
	mov rax, 3
	mul r13
	mul r9
	mov r14, rax

loop1:
	movzx rax, byte ptr [RCX + r11]
	cvtsi2ss xmm0, rax
	mov r9, 1
	jmp newPixelValues
continue1:
	
	cvttss2si r10, xmm4
	mov byte ptr [RCX + r11], r10b
	add r11, 1
	sub r14, 1
	cmp r14, 0
	jne loop1
	jmp end2


heightLoop:

	;dodanie tablicy dla nowych wartoœci?
	;liczenie osobn¹ etykiet¹ wspóln¹ dla RGB

	movzx rax, byte ptr [RCX + r11]
	cvtsi2ss xmm0, rax
	movzx rax, byte ptr [RCX + r11 +1]
	cvtsi2ss xmm1, rax
	movzx rax, byte ptr [RCX + r11 +2]
	cvtsi2ss xmm2, rax

	mov rax, 1
	jmp newPixelValues

;continue1:
	cvttss2si r10, xmm4
	mov byte ptr [RCX + r11], r10b 
	cvttss2si r10, xmm5
	mov byte ptr [RCX + r11 +1], r10b 
	cvttss2si r10, xmm6
	mov byte ptr [RCX + r11 +2], r10b 

	add r11, 3
	sub r13, 1
widthLoop:    ;dodaæ dobre warunki							

	movzx rax, byte ptr [RCX + r11]
	cvtsi2ss xmm0, rax
	movzx rax, byte ptr [r15 + r11 +1]
	cvtsi2ss xmm1, rax
	movzx rax, byte ptr [r15 + r11 +2]
	cvtsi2ss xmm2, rax

	mov rax, 2
	jmp newPixelValues

continue2:
	cvttss2si r10, xmm4
	mov byte ptr [r15 + r11], r10b 
	cvttss2si r10, xmm5
	mov byte ptr [r15 + r11 +1], r10b 
	cvttss2si r10, xmm6
	mov byte ptr [r15 + r11 +2], r10b

	add r11, 3
	sub r13, 1                             ;decrement counter
	cmp r13, 1                              ;check if the end of array 
	jnz widthLoop                            ;if not jump to mainLoop

	;end of widthLoop
	mov r13, r8

	movzx rax, byte ptr [r15 + r11]
	cvtsi2ss xmm0, rax
	movzx rax, byte ptr [r15 + r11 +1]
	cvtsi2ss xmm1, rax
	movzx rax, byte ptr [r15 + r11 +2]
	cvtsi2ss xmm2, rax
	
	mov rax, 3
	jmp newPixelValues

continue3:
	cvttss2si r10, xmm4
	mov byte ptr [r15 + r11], r10b 
	cvttss2si r10, xmm5
	mov byte ptr [r15 + r11 +1], r10b 
	cvttss2si r10, xmm6
	mov byte ptr [r15 + r11 +2], r10b 


	add r11, 3
	sub r9, 1                             ;decrement counter
	cmp r9, 0                              ;check if the end of array 
	jnz heightLoop                            ;if not jump to mainLoop

	;end of HeightLoop
	mov r13, r8
secondWidthLoop:  ;dodaæ dobre warunki

	movzx rax, byte ptr [r15 + r11]
	cvtsi2ss xmm0, rax
	movzx rax, byte ptr [r15 + r11 +1]
	cvtsi2ss xmm1, rax
	movzx rax, byte ptr [r15 + r11 +2]
	cvtsi2ss xmm2, rax

	mov rax, 4
	jmp newPixelValues

continue4:
	cvttss2si r10, xmm4
	mov byte ptr [r15 + r11], r10b 
	cvttss2si r10, xmm5
	mov byte ptr [r15 + r11 +1], r10b 
	cvttss2si r10, xmm6
	mov byte ptr [r15 + r11 +2], r10b 

	add r11, 3
	sub r13, 1                             ;decrement counter
	cmp r13, 0                             ;check if the end of array 
	jnz secondWidthLoop                            ;if not jump to mainLoop

	jmp end2


newPixelValues:							;(numberOfBits * old B/ 255) * (255 / numberOfBits)
	movq xmm4, xmm3
	mulps xmm4, xmm0           ;!!!!!!!!!!!!!!
	divss xmm4, dword ptr my255
	cvttss2si r10, xmm4
	mov rax, r10
	mul r12
	cvtsi2ss xmm4, rax

							;(numberOfBits * oldG / 255) * (255 / numberOfBits)
	movq xmm5, xmm3
	mulss xmm5, xmm1
	divss xmm5, dword ptr my255
	mulss xmm5, xmm7
							;(numberOfBits * oldR / 255) * (255 / numberOfBits)
	movq xmm6, xmm3
	mulss xmm6, xmm2
	divss xmm6, dword ptr my255
	mulss xmm6, xmm7

	cmp r9, 1
	je continue1
	cmp r9, 2
	je continue2
	cmp rdx, 3
	je continue3
	cmp rdx, 4
	je	continue4

end2:
	xor rax, rax						   ; clear clutter
	mov rax, rdx						   ; move time of execution to rax
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop rbx
pop rsi
pop rdi
pop rbp

	ret
AlghoritmCalculator endp
end