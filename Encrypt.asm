include \masm32\include\masm32rt.inc

.data
msizePrompt	BYTE "Enter the size of the message (1-50): ", 0
messPrompt	BYTE "Enter the message: ", 0
ksizePrompt	BYTE "Enter the size of the key (1-50): ", 0
keyPrompt	BYTE "Enter the key: ", 0
cipher      BYTE "Encrpyted message:", 0ah, 0dh, 0
message		BYTE 50 DUP(0), 0
key			BYTE 50 DUP(0), 0
fullKey		BYTE 50 DUP(0), 0
encrypted	BYTE 50 DUP(0), 0	
mszStr		BYTE 8 DUP(0), 0
kszStr		BYTE 8 DUP(0), 0
msz			DWORD ?
ksz			DWORD ?
crlf BYTE 0ah, 0dh, 0


.code
main proc
	;read in a string
	invoke StdOut, ADDR msizePrompt
	invoke StdIn, ADDR mszStr, 7
	invoke atodw, ADDR mszStr
	mov msz, eax

	invoke StdOut, ADDR messPrompt
	invoke StdIn, ADDR message, 50

	invoke StdOut, ADDR ksizePrompt
	invoke StdIn, ADDR kszStr, 7
	invoke atodw, ADDR kszStr
	mov ksz, eax

	invoke StdOut, ADDR keyPrompt
	invoke StdIn, ADDR key, 50

	;Fill the key
	;loop through esi which is key for len edi (size)
	mov esi, OFFSET key      ; &key
	mov edi, OFFSET fullKey
	mov ecx, ksz
	mov ebx, msz
	jmp fillKey
reloop:
	mov ecx, ksz
	mov esi, OFFSET key
	jmp backOne
fillKey:
	xor eax, eax
	mov al, [esi]
	mov [edi], al

	inc edi
	inc esi
	dec ecx
	cmp ecx, 1
	jl reloop
backOne:
	dec ebx
	cmp ebx, 1   ; <- These 3 lines are the broken down loop command
	jge fillKey

	;Encryption
	mov esi, OFFSET message  ; &message
	mov edi, OFFSET fullKey      ; &key
	mov edx, OFFSET encrypted  ; &encrypt
	mov ecx,  msz
	jmp encrypt
overflow: 
	sub al, 26
	mov [edx], al
	jmp backTwo	  
encrypt:
	xor eax, eax
	xor ebx, ebx
	mov al, [esi]			;*esi message
	mov bl, [edi]			;*esp fullKey
	sub bl, 65   ; sub 65
	add al, bl
	cmp al, 90
	jg overflow
	mov [edx], al
backTwo:
	inc esi
	inc edi	
	inc edx
	dec ecx
	cmp ecx, 0
	jne encrypt

	invoke StdOut, ADDR cipher
	invoke StdOut, ADDR encrypted

	;return 0
	mov eax, 0
	ret

main endp
end main