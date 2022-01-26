OPTION CASEMAP:NONE
;Author: Paulina Nieradzik 
;gr1 sek2 sem5 2021/2022
;Topic: Implementation of dithering Floyd-Steinberg alghoritm
;Descryption: Floyd-Steinberg alghoritm is a dithering alghoritm which use error diffusion -
;it adds the residual quantization error of a pixel onto its neighboring pixels, to be dealt with later.
;Version: 1.0
.NOLIST
.NOCREF
.LIST

.data 
padding DQ 0
my255 DD 0437f0000r							;delare 255 in float
my7l16 DQ 3FDC000000000000r
my3l16 DQ 3FC8000000000000r
my5l16 DQ 3FD4000000000000r
my1l16 DQ 3FB0000000000000r

.code
;Procedure AlghoritmCalculator convetrs picture with Floyd-Steinberg alghoritm
;Takes 4 arguments: pointer to byte array, number of bits (from 1 to 16) in resulting picture, picture width and height.
;Returns alghoritm execution time
AlghoritmCalculator proc					;first argument - pointer to byte array - RCX
											;second argument - number of bits in picture - RDX
											;third - picture width - R8
											;fourth - picture height - R9
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

	mov r15, RDX							;number of bits in picture

	rdtsc									;start measuring time
	shl rdx, 32 
	or rdx, rax 
	mov r10, rdx  
	push r10

	mov r13, R8								;picture width
	xor r11, r11							;byte array counter
	xor r10, r10
	xor r14, r14
	xorps xmm0,xmm0							;oldB
	xorps xmm1,xmm1							;oldG
	xorps xmm2,xmm2							;oldR
	xorps xmm3,xmm3							;numberOfBits
	xorps xmm4, xmm4						;newB
	xorps xmm5, xmm5						;newG
	xorps xmm6, xmm6						;newR
	xorps xmm7, xmm7						;errB
	xorps xmm8, xmm8						;errG
	xorps xmm9, xmm9						;errR
	xorps xmm10, xmm10
	cvtsi2ss xmm3, r15						;convert numberOfBits to float
	mov rax, 255
	cdq
	idiv r15
	mov r12, rax							;255/numberOfBits in r12
	mov rax, r8
	mov r10, 4
	cdq
	idiv r10
	mul r10
	mov rdx, rax
	mov rax, r8
	sub rax, rdx
	mov dword ptr padding, eax

	sub r9, 1								;height-1

heightLoop:										;height-1 times
	movzx rax, byte ptr [RCX + r11]				;array[i] -> rax (oldB int)
	cvtsi2ss xmm0, rax							;oldB value to xmm0 in float
	movzx rax, byte ptr [RCX + r11 +1]			;array[i+1] -> rax (oldG int)
	cvtsi2ss xmm1, rax							;oldG value to xmm0 in float
	movzx rax, byte ptr [RCX + r11 +2]			;array[i+2] -> rax (oldR int)
	cvtsi2ss xmm2, rax							;oldR value to xmm0 in float

	mov r14, 1									;place to return
	jmp newPixelValues							;calculation of new values B,G and R

continue1:
	cvttss2si r10, xmm4							;float -> int  newB
	mov byte ptr [RCX + r11], r10b				;change the byte value
	cvttss2si r10, xmm5							;float -> int  newG
	mov byte ptr [RCX + r11 +1], r10b			;change the byte value
	cvttss2si r10, xmm6							;float -> int  newR
	mov byte ptr [RCX + r11 +2], r10b			;change the byte value

	add r11, 3									;i+=3
	sub r13, 1									;width-1

widthLoop:										;width-2 times
	movzx rax, byte ptr [RCX + r11]				;array[i] -> rax (oldB int)
	cvtsi2ss xmm0, rax							;oldB value to xmm0 in float
	movzx rax, byte ptr [RCX + r11 +1]			;array[i+1] -> rax (oldG int)
	cvtsi2ss xmm1, rax							;oldG value to xmm0 in float
	movzx rax, byte ptr [RCX + r11 +2]			;array[i+2] -> rax (oldR int)
	cvtsi2ss xmm2, rax							;oldR value to xmm0 in float

	mov r14, 2									;place to return
	jmp newPixelValues							;calculation of new values B,G and R

continue2:
	cvttss2si r10, xmm4							;float -> int  newB
	mov byte ptr [RCX + r11], r10b				;change the byte value
	cvttss2si r10, xmm5							;float -> int  newG
	mov byte ptr [RCX + r11 +1], r10b			;change the byte value
	cvttss2si r10, xmm6							;float -> int  newR
	mov byte ptr [RCX + r11 +2], r10b

	movq xmm7, xmm0								;errB = oldB
	subss xmm7, xmm4							;errB = oldB - newB
	cvtss2sd xmm7, xmm7
	movq xmm8, xmm1								;errG = oldG
	subss xmm8, xmm5							;errG = oldG - newG
	cvtss2sd xmm8, xmm8
	movq xmm9, xmm2								;errR = oldR
	subss xmm9, xmm6							;errr = oldR - newR
	cvtss2sd xmm9, xmm9

	jmp calcuateErrorDiffusion

return:
	add r11, 3									;i+=3
	sub r13, 1									;decrement widthLoop counter
	cmp r13, 1									;check if the end widthLoop
	jnz widthLoop								;if not jump to widthLoop

	;end of widthLoop
	mov r13, r8									;move image width to widthLoop counter

	movzx rax, byte ptr [RCX + r11]				;array[i] -> rax (oldB int)
	cvtsi2ss xmm0, rax							;oldB value to xmm0 in float
	movzx rax, byte ptr [RCX + r11 +1]			;array[i+1] -> rax (oldG int)
	cvtsi2ss xmm1, rax							;oldG value to xmm0 in float
	movzx rax, byte ptr [RCX + r11 +2]			;array[i+2] -> rax (oldR int)
	cvtsi2ss xmm2, rax							;oldR value to xmm0 in float
	
	mov r14, 3									;place to return
	jmp newPixelValues							;calculation of new values B,G and R

continue3:
	cvttss2si r10, xmm4							;float -> int  newB
	mov byte ptr [RCX + r11], r10b				;change the byte value
	cvttss2si r10, xmm5							;float -> int  newG
	mov byte ptr [RCX + r11 +1], r10b			;change the byte value
	cvttss2si r10, xmm6							;float -> int  newR
	mov byte ptr [RCX + r11 +2], r10b			;change the byte value

	add r11, 3									;i+=3
	add r11, qword ptr padding
	sub r9, 1									;decrement heightLoop counter
	cmp r9, 0									;check if the end of heightLoop
	jnz heightLoop								;if not jump to heightLoop

	;end of HeightLoop
	mov r13, r8

secondWidthLoop:								;width times
	movzx rax, byte ptr [RCX + r11]				;array[i] -> rax (oldB int)
	cvtsi2ss xmm0, rax							;oldB value to xmm0 in float
	movzx rax, byte ptr [RCX + r11 +1]			;array[i+1] -> rax (oldG int)
	cvtsi2ss xmm1, rax							;oldG value to xmm0 in float
	movzx rax, byte ptr [RCX + r11 +2]			;array[i+2] -> rax (oldR int)
	cvtsi2ss xmm2, rax							;oldR value to xmm0 in float

	mov r14, 4									;place to return
	jmp newPixelValues							;calculation of new values B,G and R

continue4:
	cvttss2si r10, xmm4							;float -> int  newB
	mov byte ptr [RCX + r11], r10b				;change the byte value
	cvttss2si r10, xmm5							;float -> int  newG
	mov byte ptr [RCX + r11 +1], r10b			;change the byte value
	cvttss2si r10, xmm6							;float -> int  newR
	mov byte ptr [RCX + r11 +2], r10b			;change the byte value

	add r11, 3									;i+=3
	sub r13, 1									;decrement counter
	cmp r13, 0									;check if the end of secondWidthLoop
	jnz secondWidthLoop                         ;if not jump to secondWidthLoop
	jmp end2									;jump to end of function

newPixelValues:									;(numberOfBits * old B/ 255) * (255 / numberOfBits)
	movq xmm4, xmm3								;calculateo of newB value
	mulps xmm4, xmm0							
	divss xmm4, dword ptr my255					
	cvttss2si r10, xmm4							;numberOfBits * oldB /255 -> int r10
	mov rax, r10
	mul r12										;(numberOfBits * old B/ 255) * (255 / numberOfBits) in rax
	cvtsi2ss xmm4, rax							;newB in xmm4

												;(numberOfBits * oldG / 255) * (255 / numberOfBits)
	movq xmm5, xmm3								;calculate of newG value
	mulps xmm5, xmm1							
	divss xmm5, dword ptr my255				
	cvttss2si r10, xmm5							;numberOfBits * oldG /255 -> int r10
	mov rax, r10
	mul r12										;(numberOfBits * oldG/ 255) * (255 / numberOfBits) in rax
	cvtsi2ss xmm5, rax							;newG in xmm5

												;(numberOfBits * oldR/ 255) * (255 / numberOfBits)
	movq xmm6, xmm3								;calculate of newR value
	mulps xmm6, xmm2
	divss xmm6, dword ptr my255
	cvttss2si r10, xmm6							;numberOfBits * oldR /255 -> int r10
	mov rax, r10
	mul r12										;(numberOfBits * oldR/ 255) * (255 / numberOfBits) in rax
	cvtsi2ss xmm6, rax							;newR in xmm6

	cmp r14, 1
	je continue1								;jump to first part of heightLoop
	cmp r14, 2
	je continue2								;jump to widthLoop
	cmp r14, 3
	je continue3								;jump to end of heightLoop
	cmp r14, 4
	je continue4								;jump to secondWidthLoop

calcuateErrorDiffusion:
	mov rax, 3
	mul r8
	mov r14, rax
	;first pixel
	movzx rax, byte ptr [RCX + r11 +3]				;array[i] -> rax (oldB int)
	cvtsi2sd xmm0, rax							;oldB value to xmm0 in float
	movzx rax, byte ptr [RCX + r11 +1 + 3]			;array[i+1] -> rax (oldG int)
	cvtsi2sd xmm1, rax							;oldG value to xmm0 in float
	movzx rax, byte ptr [RCX + r11 +2 + 3]			;array[i+2] -> rax (oldR int)
	cvtsi2sd xmm2, rax							;oldR value to xmm0 in float
	movq xmm10, my7l16
	mulsd xmm10, xmm7
	addsd xmm10, xmm0
	cvttsd2si  r10, xmm10
	cmp r10, 255
	jg changeto255B1
	jmp lower0B1
changeto255B1:
	mov r10, 255
	jmp writeB1
lower0B1:
	cmp r10, 0
	jl changeto0B1
	jmp writeB1
changeto0B1:
	mov r10, 0
writeB1:
	mov byte ptr [RCX + r11 +3], r10b

	movq xmm10, my7l16
	mulsd xmm10, xmm8
	addsd xmm10, xmm1
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255G1
	jmp lower0G1
changeto255G1:
	mov r10, 255
	jmp writeG1
lower0G1:
	cmp r10, 0
	jl changeto0G1
	jmp writeG1
changeto0G1:
	mov r10, 0
writeG1:
	mov byte ptr [RCX + r11 + 1 + 3], r10b

	movq xmm10, my7l16
	mulsd xmm10, xmm9
	addsd xmm10, xmm2
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255R1
	jmp lower0R1
changeto255R1:
	mov r10, 255
	jmp writeR1
lower0R1:
	cmp r10, 0
	jl changeto0R1
	jmp writeR1
changeto0R1:
	mov r10, 0
writeR1:
	mov byte ptr [RCX + r11 + 2 + 3], r10b

	;second pixel
	mov r15, r14
	add r15, r11
	movzx rax, byte ptr [RCX + r15 -3]				;array[i] -> rax (oldB int)
	cvtsi2sd xmm0, rax							;oldB value to xmm0 in float
	movzx rax, byte ptr [RCX + r15 -2]			;array[i+1] -> rax (oldG int)
	cvtsi2sd xmm1, rax							;oldG value to xmm0 in float
	movzx rax, byte ptr [RCX + r15 +2 -3]			;array[i+2] -> rax (oldR int)
	cvtsi2sd xmm2, rax							;oldR value to xmm0 in float
	movq xmm10, my3l16
	mulsd xmm10, xmm7
	addsd xmm10, xmm0
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255B2
	jmp lower0B2
changeto255B2:
	mov r10, 255
	jmp writeB2
lower0B2:
	cmp r10, 0
	jl changeto0B2
	jmp writeB2
changeto0B2:
	mov r10, 0
writeB2:
	mov byte ptr [RCX + r15 -3], r10b

	movq xmm10, my3l16
	mulsd xmm10, xmm8
	addsd xmm10, xmm1
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255G2
	jmp lower0G2
changeto255G2:
	mov r10, 255
	jmp writeG2
lower0G2:
	cmp r10, 0
	jl changeto0G2
	jmp writeG2
changeto0G2:
	mov r10, 0
writeG2:
	mov byte ptr [RCX + r15 + 1 -3], r10b

	movq xmm10, my3l16
	mulsd xmm10, xmm9
	addsd xmm10, xmm2
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255R2
	jmp lower0R2
changeto255R2:
	mov r10, 255
	jmp writeR2
lower0R2:
	cmp r10, 0
	jl changeto0R2
	jmp writeR2
changeto0R2:
	mov r10, 0
writeR2:
	mov byte ptr [RCX + r15  + 2 -3], r10b

	;third pixel
	movzx rax, byte ptr [RCX + r15]				;array[i] -> rax (oldB int)
	cvtsi2sd xmm0, rax							;oldB value to xmm0 in float
	movzx rax, byte ptr [RCX + r15 +1]			;array[i+1] -> rax (oldG int)
	cvtsi2sd xmm1, rax							;oldG value to xmm0 in float
	movzx rax, byte ptr [RCX + r15 +2]			;array[i+2] -> rax (oldR int)
	cvtsi2sd xmm2, rax							;oldR value to xmm0 in float
	movq xmm10, my5l16
	mulsd xmm10, xmm7
	addsd xmm10, xmm0
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255B3
	jmp lower0B3
changeto255B3:
	mov r10, 255
	jmp writeB3
lower0B3:
	cmp r10, 0
	jl changeto0B3
	jmp writeB3
changeto0B3:
	mov r10, 0
writeB3:
	mov byte ptr [RCX + r15], r10b

	movq xmm10, my5l16
	mulsd xmm10, xmm8
	addsd xmm10, xmm1
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255G3
	jmp lower0G3
changeto255G3:
	mov r10, 255
	jmp writeG3
lower0G3:
	cmp r10, 0
	jl changeto0G3
	jmp writeG3
changeto0G3:
	mov r10, 0
writeG3:
	mov byte ptr [RCX + r15 + 1 ], r10b

	movq xmm10, my5l16
	mulsd xmm10, xmm9
	addsd xmm10, xmm2
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255R3
	jmp lower0R3
changeto255R3:
	mov r10, 255
	jmp writeR3
lower0R3:
	cmp r10, 0
	jl changeto0R3
	jmp writeR3
changeto0R3:
	mov r10, 0
writeR3:
	mov byte ptr [RCX + r15 + 2], r10b
	
	;fourthpixel
	movzx rax, byte ptr [RCX + r15 +3]				;array[i] -> rax (oldB int)
	cvtsi2sd xmm0, rax							;oldB value to xmm0 in float
	movzx rax, byte ptr [RCX + r15 +1 +3]			;array[i+1] -> rax (oldG int)
	cvtsi2sd xmm1, rax							;oldG value to xmm0 in float
	movzx rax, byte ptr [RCX + r15 +2 +3]			;array[i+2] -> rax (oldR int)
	cvtsi2sd xmm2, rax							;oldR value to xmm0 in float
	movq xmm10, my1l16
	mulsd xmm10, xmm7
	addsd xmm10, xmm0
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255B4
	jmp lower0B4
changeto255B4:
	mov r10, 255
	jmp writeB4
lower0B4:
	cmp r10, 0
	jl changeto0B4
	jmp writeB4
changeto0B4:
	mov r10, 0
writeB4:
	mov byte ptr [RCX + r15 +3], r10b

	movq xmm10, my1l16
	mulsd xmm10, xmm8
	addsd xmm10, xmm1
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255G4
	jmp lower0G4
changeto255G4:
	mov r10, 255
	jmp writeG4
lower0G4:
	cmp r10, 0
	jl changeto0G4
	jmp writeG4
changeto0G4:
	mov r10, 0
writeG4:
	mov byte ptr [RCX + r15 + 1 +3], r10b

	movq xmm10, my1l16
	mulsd xmm10, xmm9
	addsd xmm10, xmm2
	cvttsd2si r10, xmm10
	cmp r10, 255
	jg changeto255R4
	jmp lower0R4
changeto255R4:
	mov r10, 255
	jmp writeR4
lower0R4:
	cmp r10, 0
	jl changeto0R4
	jmp writeR4
changeto0R4:
	mov r10, 0
writeR4:
	mov byte ptr [RCX + r15 + 2 +3], r10b

	jmp return

	;//Pixel(x + 1, y);
                    ;int b = image[i + 3];
                    ;int g = image[i + 1 + 3];
                    ;int r = image[i + 2 + 3];
                    ;r = (int)(r + errR * 7 / 16.0);
                    ;g = (int)(g + errG * 7 / 16.0);
                    ;b = (int)(b + errB * 7 / 16.0);
                    ;r = r > 255 ? 255 : r;
                    ;g = g > 255 ? 255 : g;
                    ;b = b > 255 ? 255 : b;
                    ;r = r < 0 ? 0 : r;
                    ;g = g < 0 ? 0 : g;
                    ;b = b < 0 ? 0 : b;
                    ;image[i + 3] = (byte)b;
                    ;image[i + 1 + 3] = (byte)g;
                    ;image[i + 2 + 3] = (byte)r;


end2:
	rdtsc										;stop measuring time
	shl rdx, 32 
	or rdx, rax 
	pop r10										;read previous time
	sub rdx, r10

	xor rax, rax								;clear clutter
	mov rax, rdx								;move time of execution to rax
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