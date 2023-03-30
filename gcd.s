;	Code: Pablo Boudet Nieto & Stephen Blythe
;	Date: 12/01/2021
;	This file will use a recursive algorithm to calculate the GCD of the numbers stored in rax and rbx
;
	
	section	.text
	global		gcd
	
gcd:
	cmp		rbx, 0 	;compare rbx to 0
	je		equal		;if 0 jump to equal
	
	cmp		rax, rbx	;compare rax to rbx
	jl		lessthan	;if rax < rbx jump to lessthan label

;If none of this conditions is matched it means that rbx <= rax then:

greater_or_eq:
	push		rbx		;we will keep the value of rbx from changing
	
	mov		rdx,0		;make rdx equals 0 to prevent any error
	idiv		rbx		;divide rax by rbx
	mov		rbx, rdx	;store the reminder in rbx
	
	pop 		rax		;get the pushed(old) value of rbx into rax 
	
	call		gcd		;use recursion to continue to the solution

;If rax < rbx then we will make rax be rbx and viceversa

lessthan:
	push		rax		;push rax into the stack
	push		rbx		;push rbx into the stack
	
	pop 		rax		;get the old rbx into rax
	pop		rbx		;get the old rax value into rbx
	
	call		gcd		;go back to the gcd label

; Since rbx is equal to 0 we know that the solution will be rax and return to main file to print rax

equal:
	ret

	


	
