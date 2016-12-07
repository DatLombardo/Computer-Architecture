include \masm32\include\masm32rt.inc

.data
;Part 1
exitIt		BYTE "Press 'Enter' to end", 0ah, 0dh, 0
exitOut		DWORD ?
numPrompt	BYTE "Enter a Positive Number: ", 0
notPrompt	BYTE "The number is not Prime.", 0 
isPrompt	BYTE "The number is Prime.", 0 
numStr		BYTE 12 DUP(0), 0
num			DWORD ?
i			DWORD ?
;Part 2
strPrompt	BYTE "Enter the string: ", 0
notPal		BYTE "This string is not a Palindrome", 0
isPal		BYTE "This string is a Palindrome", 0
forward		BYTE 50 DUP(0), 0
reverse		BYTE 50 DUP(0), 0	
numChars	DWORD ?

crlf		BYTE 0ah, 0dh, 0  ; variable to make a new line

.code
;Part 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
isPrime proc
	mov eax, [esp+4]
	;CHECK IF NUMBER IS LESS THAN 2, OBVIOUSLY PRIME.
	cmp eax, 3
	jl isPrimeNum
	sub eax, 1
	mov i, eax
	mov ecx, i
	
findPrime:
	mov edx, 0
	mov eax, num
	mov ebx, i
	div ebx
	cmp edx, 0
	je notPrime

	mov ecx, i
	dec ecx
	mov i, ecx
	cmp ecx, 1 
	jnz findPrime
	jmp isPrimeNum
notPrime:
	invoke StdOut, ADDR notPrompt
	invoke StdOut, ADDR crlf
	jmp endIt
isPrimeNum:
	invoke StdOut, ADDR isPrompt
	invoke StdOut, ADDR crlf
endIt:
	ret 4
isPrime endp



main proc
	invoke StdOut, ADDR numPrompt
	invoke StdIn, ADDR numStr, 11     ; Get guess
	invoke atodw, ADDR numStr
	mov num, eax
	pushd num
	call isPrime
;Part 2   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	invoke StdOut, ADDR strPrompt
	invoke StdIn, ADDR forward, 50
	mov numChars, eax
	mov ecx, eax
	mov esi, OFFSET forward      ; &forward
pushLoop:
	xor eax, eax      
	mov al, [esi]    
	push eax
	inc esi
	loop pushLoop
	mov ecx, numChars
	mov edi, OFFSET reverse
popLoop:	
	pop eax
	mov [edi] ,al
	inc edi
	loop popLoop

	mov esi, OFFSET forward      ; &forward
	mov edi, OFFSET reverse
	mov ecx, numChars
compare:
	mov eax, 0
	mov ebx, 0
	mov al, [esi]
	mov bl, [edi]
	cmp al, bl
	jne notPalin

	inc esi 
	inc edi
	loop compare
	jmp isPalin
notPalin:
	invoke StdOut, ADDR notPal
	invoke StdOut, ADDR crlf 
	jmp finish
isPalin:
	invoke StdOut, ADDR isPal
	invoke StdOut, ADDR crlf
finish:
	invoke StdOut, ADDR exitIt
	invoke StdIn, ADDR exitOut, 8
	mov eax, 0
	ret

main endp
end main
