assume CS:code, DS:data

data segment
    rez dw ? ; rez = cuv_C
    temp db ?

data ends

code segment

;calculeaza cuvantul c si retine rezultatul in rez
    CalculCuvC PROC
	;------------Bitii 0-3----
	mov al, sir[0]
	mov cl,4
	shr al,cl
	
	mov bl, l 
	mov bh, 0
 	mov si, bx

	dec si
	mov bl, sir[si]
	and bl, 00001111b
	xor al, bl

	;------------Bitii 4-7-----
	mov cl, l
	mov ch, 0
	;cx=l
	mov si, 0
	mov temp, 0

	repeta:
	mov bl, sir[si]
	and bl, 00111100b
	or temp, bl
	inc si
	loop repeta

	mov cl, 2
	shl temp, cl

	or al, temp
	;-- al = xxxx xxxx

	mov ah, 0
	mov rez, ax


	;------------Bitii 10-15
	mov cl, l
	mov ch, 0
	; cx= l
	mov si, 0
	mov bx, 0

	repeta2:
	mov al, sir[si]
	mov ah, 0
	add bx, ax
	inc si
	loop repeta2
	;-- ax = suma tutuor elementelor din sir

	mov ax, bx
	;-- al = ax mod 256 -> adica ultimii 8 biti

	mov ah, al
	mov al, 0
	;-- ax = xxxx xxxx 0000 0000 iar rez = 0000 0000 xxxx xxxx
	or rez, ax
	; rez = cuvantul c

  ret
  CalculCuvC ENDP


  ;roteste fiecare element din sir cu suma primilor 2 biti din configuratie
  Rotiri_s2 PROC
	mov cl, l
	mov ch, 0
	; cx= l
	mov si, 0


	rot:
	xor bl, bl ; <=> mov bl, 0
	mov al, sir[si]
	shr al, 1
	adc bl,0
	shr al, 1
	adc bl,0

	push cx ; salvez valoarea lui cx in stiva

	mov cl, bl
	mov al, sir[si]
	rol al, cl
	mov sir[si], al

	pop cx ; scot valoarea lui cx din stiva pentru a nu afecta loopul cand modific cl
	inc si

	loop rot
  ret
  Rotiri_s2 ENDP

  AfisareBaza2 PROC
	mov bx, rez
	mov cx, 16
	afis_s2:
	shl bx, 1
	jc unu
	
	mov ah, 02h
	mov dl, '0'
	int 21h

	continua:
	loop afis_s2

	jmp endAfisB2
	
	unu:
	mov ah, 02h
	mov dl, '1'
	int 21h
	jmp continua
	
	endAfisB2:

	mov ah, 09h
	mov dx, offset mesaj_new_line
	int 21h
  ret
  AfisareBaza2 ENDP

start:
    mov ax, data
    mov ds, ax

; mesaj pentru input
    mov dx, offset mesaj_input
    call afisare_mesaj
    call endl
    call pauza

; todo citire
; todo conversie, cuvantul C etc.
 
    call CalculCuvC
    ;call Rotiri_s2

    call sort
    call max_biti_setati
    cmp bl, 4
    jb sub_4_biti_setati
    minim_4_biti_setati:
        mov dx, offset mesaj_biti_setati_max
        call afisare_mesaj
        mov al, bh
        call afisare_al_hex
        call endl
        jmp dupa_max_biti
    sub_4_biti_setati:
        mov dx, offset mesaj_biti_setati_fail
        call afisare_mesaj
        call endl

    dupa_max_biti:

    call pauza
    
    call AfisareBaza2    

    mov ax, 4C00h
    int 21h
code ends
end start

