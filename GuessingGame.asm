include \masm32\include\masm32rt.inc

.data
opening		BYTE "Welcome to Guessing Game! The number is random between 0-500.", 0ah, 0dh, 0
guessRemain BYTE "Guessing Remaining: %d", 0ah, 0dh, 0
lowMessage	BYTE "Your guess was too high, Lower!", 0ah, 0dh, 0
highMessage BYTE "Your guess was too low, Higher!", 0ah, 0dh, 0
winMessage	BYTE "Congrats! You win! The number was %d", 0ah, 0dh, 0
loseMessage	BYTE "You have ran out of tries, the number was %d", 0ah, 0dh, 0
closing		BYTE "Thank you for playing Guessing Game!", 0ah, 0dh, 0
exitIt		BYTE "Press 'Enter' to end game", 0ah, 0dh, 0
exitOut		DWORD ?
guessPrompt	BYTE "Guess the number (0-500): ", 0
crlf		BYTE 0ah, 0dh, 0  ; variable to make a new line
randz		DWORD ?
guessStr	BYTE 8 DUP(8), 0
guess		DWORD ?
numTries	DWORD 8

.code
	seedrand proc
		;seeds the random number generator
		invoke GetTickCount  ; result goes into eax
		invoke nseed, eax
		ret
	seedrand endp

	randomnum proc
		;generate a random number
		mov eax, [esp+4]   ; move the return address, as it is passed on the stack
		invoke nrandom, eax
		ret 4 ; grab return address then clear the stack
	randomnum endp

main proc
	invoke StdOut, ADDR opening
	call seedrand
	pushd 500 ; Maximum Value
	call randomnum
	mov randz, eax
	mov ebx, eax

	xor eax, eax
	mov ecx, numTries
	jmp guessLoop

higher:
	invoke StdOut, ADDR highMessage
	invoke StdOut, ADDR crlf
	jmp returnTo
lower:
	invoke StdOut, ADDR lowMessage
	invoke StdOut, ADDR crlf
	jmp returnTo

guessLoop:
	invoke crt_printf, ADDR guessRemain, ecx
	invoke StdOut, ADDR guessPrompt
	invoke StdIn, ADDR guessStr, 7     ; Get guess
	invoke atodw, ADDR guessStr
	mov guess, eax

	cmp ebx, eax
	jg higher
	jl lower
	je win
returnTo:
	mov ecx, numTries
	dec ecx
	mov numTries, ecx
	cmp ecx, 0   
	jnz guessLoop
	jmp lose

win:
	invoke StdOut, ADDR crlf
	invoke crt_printf, ADDR winMessage, ebx
	jmp after

lose:
	invoke StdOut, ADDR crlf
	invoke crt_printf, ADDR loseMessage, ebx
after:
	invoke StdOut, ADDR closing
	invoke StdOut, ADDR exitIt
	invoke StdIn, ADDR exitOut, 8
	mov eax, 0
	ret

main endp
end main
