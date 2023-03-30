;	Code: Pablo Boudet Nieto & Stephen Blythe
;	Date: 12/01/2021
;	Program: GCD recursive calculator in Intel Assembly Language of two positive numbers
;
	
	section 	.data
	prompt: db "Enter first number: "  						;ask for the first numbers
	prompt2:db "Enter Second number: "						;ask for the second number
	prompt3:db "The GCD of "							;First part of the answer
	prompt4:db " and "								;Part of the answer between the two numbers
	prompt5:db " is "								;Part of the answer before the solution
	prompt6:db ".", 0xA								;period and stop
	
	
	section	.bss								;Declarartion of the Buffers
	buff:	resb 100								;"reserve" 100 bytes
	buff2:  resb 100								;"reserve" 100 Bytes
	
	section  	.text			
	global	 	_start
	extern   	gcd								;"import" gcd file
	extern		print								;"import" print file
	

_start:			
	;Print the prompt asking for the first number
	
	mov		rdx, 0x14		;16 characters
	mov		rcx, prompt		;where characters start
	mov		rax, 4			;write
	mov		rbx, 1			;stdout
	int		0x80

	; read from keyboard (stdin=0), no more than 100 bytes (chars)
	mov		rax, 3			; read
	mov		rbx, 0			; from stdin
	mov		rcx, buff 		; start of storage
	mov		rdx, 100		; no more than 0x64 chars
	int		0x80
	
	dec		rax			; deduce 0xA input from the total number of char
	mov		rsi, rax		; store the number of characarcter of the input in the rsi
	mov		rax, 0x0		; reset rax to 0
	mov		rdi, 0x0		; reset rdi to 0 (rdi will count the number of times we iterate thorugh the loop)
	mov		rbx, 10		; make rbx equal 10 


;This label will loop rax - 1 time which equal the number of char in the input and will apply the algorithm rax = rax * 10 + cl to get the actual integer from the memory as a string to the register as an int
intoregister:
	mov		rcx,0x0		; reset rcx each time we iterate through the loop
	mov		cl,[buff+rdi]		; move the value from the buffer to the last part of the rcx register
	sub		rcx, '0'		; convert from ascii to base 10
	
	cqo					; make rdx equals 0
	mul		rbx			; multiply rax by 10
	inc		rdi			; increase rdi by one
	add		rax, rcx		; move the las value from rcx to rax
	
	cmp		rsi,rdi		;if we have looped the same times as char in the input keep going
	jne		intoregister		; if we have not go back to intoregister label
	

	
	push		rax			;store rax to keep it safe from variations in the following code sequence

print2:	
	; print prompt 2			
	 mov 		rax, 4 	; write
	 mov 		rbx, 1 	; stdout
	 mov 		rcx, prompt2    ; where characters start
	 mov 		rdx, 0x15       ; 21 characters
	 int 		0x80

	; read from keyboard (stdin=0), no more than 100 bytes (chars)
	mov		rax, 3		; read
	mov		rbx, 0		; from stdin
	mov		rcx, buff2	; start of storage
	mov		rdx, 100	; no more than 0x64 chars
	int		0x80
	
; the following code an the code below intoregister2 will apply the same procedure as intoregister label but with the buffer2 (for the second input/number)

	dec		rax	
	mov		rsi, rax
	mov		rax, 0x0
	mov		rdi, 0x0
	mov		rbx, 10
	
intoregister2:
	mov		rcx,0x0
	mov		cl,[buff2+rdi]	
	sub		rcx, '0'
	
	cqo
	mul		rbx
	inc		rdi
	add		rax, rcx
	
	cmp		rsi,rdi
	jne		intoregister2
	
	mov		rbx, rax
	
	pop		rax		;we get the rax pushed in line 64 because the gcd function we will use below will need the first input stored in rax
	mov		rdi, rax	;move rax to keep the value in case rax change, since we are going to need it later when printing the solution
	mov		rcx, rbx	;move rcx to keep the value in case rbx change, since we are going to need it later when printing the solution
	
	call		gcd		;call the algorithm to calculate the gcd of the numbers in rax and rbx
	
;once the GCD is calculated we store it into rax

	push		rax		;keep the GCD value safe from changes
	push		rcx		;Keep the second input number safe from changing
	push		rdi		;keep the first input value safe from changing
	
	; print the first letters sequence for the final results
	mov		rdx, 11  	;16 characters
	mov		rcx, prompt3	;where characters start
	mov		rax, 4		;write
	mov		rbx, 1		;stdout
	int		0x80		
	
	
	pop		rax		;take the first input value we pushed as rdi from the stack and put into rax because the file print will output any number stored in rax
	call		print		;print the value in rax
	
	; print the second letters sequence for the final result
	
	mov		rdx, 5 	;15 characters
	mov		rcx, prompt4	;where characters start
	mov		rax, 4		;write
	mov		rbx, 1		;stdout
	int		0x80
	
	pop 		rax		;take the second input value we pushed as rcx from the stack and put into rax because the file print will output any number stored in rax
	call		print		;print the value in rax
	
	; print the third letters sequence for the final result
	
	mov		rdx, 4		;4 characters
	mov		rcx, prompt5	;where characters start
	mov		rax, 4		;write
	mov		rbx, 1		;stdout
	int		0x80
	
	pop		rax
	call		print
	
	; print prompt			; take the GCD from the stack and move it to rax
	
	mov		rdx, 2		; 2 characters
	mov		rcx, prompt6	; where characters start
	mov		rax, 4		; write
	mov		rbx, 1		; stdout
	int		0x80


	
returncont:	
	; return control to Linux 
	mov	rax, 1
	mov	rbx, 0
	int	0x80
	
		
	
