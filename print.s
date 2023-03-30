;	Code: Stephen Blythe & Pablo Boudet Nieto
;	Date: 12/01/2021
;	This file take what is stored in rax and print it to the screen(stdout)
;
	
	section	.data	
tmplbl: db 0
	section	.text
	global		print

; print out the result
print:
	mov		rsi, 0		; so far, we've seen 0 digits
	
extractNextDigit:
	mov		rbx, 10
	cqo				; sign extend rax
	idiv		rbx		;remainder in rdx is char to print

	add		rdx, '0'	; convert edx to ASCII code


	inc		rsi		; seen one more digit
	push		rdx		; push next digit onto stack

	cmp 		rax, 0x0	; any more digits left?
	jne		extractNextDigit
	
printDigitFromStack:
	mov		[tmplbl], al	; put digit into string to print
	
	;;;  print out 1 character string starting at tmplbl
	mov		eax, 0x4
	mov		ebx, 0x1
	mov		ecx, tmplbl
	mov		edx, 0x1
	int		0x80
	pop		rax		; pop next digit from stack
	mov		[tmplbl], al	; put digit into string to print
	
	;;;  print out 1 character string starting at tmplbl
	mov		eax, 0x4
	mov		ebx, 0x1
	mov		ecx, tmplbl
	mov		edx, 0x1	
	int		0x80

	dec		rsi		; processed one more digit from stack

	cmp		rsi, 0x0	; are there digits left on the stack?
	jne		printDigitFromStack ; more digits? go deal with them ... 
	
	ret
