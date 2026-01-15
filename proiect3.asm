assume CS:code, DS:data, SS:stiva

data segment
    sir db 16 dup (?)
    l db ?
    numtohex db "0123456789ABCDEF"
    input db 33, 0, 33 dup (?)
    mesaj_input db "Introduceti 8-16 octeti in format hexa: $"
    mesaj_input_fail db "Nu ati introdus un numar corect de octeti$"
    mesaj_biti_setati_max db "Numarul cu cei mai multi biti de 1 are pozitia: $"
    mesaj_biti_setati_fail db "Niciun octet nu are cel putin 4 biti de 1 setati$"
    mesaj_sir_octeti_rotiti db "Sirul dupa rotirea octetilor este: $"
    mesaj_sir_sortat db "Sirul dupa sortare este: $"
    mesaj_cuvantul_C db "Cuvantul C este: $"
    mesaj_new_line db 0Dh, 0Ah, '$'
    mesaj_sir_binar db "Sirul in Binar: $"
    rez dw ? ; rez = cuv_C
    temp db ?
    temp2 dw ?
    binary db 16 dup (?) 
    counter db ?

data ends

stiva segment stack
    dw 512 dup (0ABCDh)
stiva ends

code segment
; afiseaza mesajul al carui offset este in dx
    afisare_mesaj:
        push ax
        pushf

        mov ah, 09h
        int 21h

        popf
        pop ax
    ret

; linie noua
    endl:
        push ax
        push dx
        pushf 

        mov dx, offset mesaj_new_line
        mov ah, 09h
        int 21h

        popf    
        pop dx
        pop ax
    ret

; pune pauza la program pana la apasarea unui caracter
    pauza:
        push ax
        pushf

        mov ah, 08h
        int 21h

        popf
        pop ax
    ret

; sorteaza sirul din "sir" cu lungimea "l" (byte)
    sort:
        push ax
        push cx
        push si
        pushf

        mov ch, 0
        mov cl, l
        jcxz finished_sort
        dec cl
        jcxz finished_sort
        bubble_outer:
            push cx
            mov cl, l
            dec cl
            mov si, cx
            bubble_inner:
                mov ah, sir[si - 1]
                cmp ah, sir[si]
                jae no_swap
                swap:
                    mov al, sir[si]
                    mov sir[si - 1], al
                    mov sir[si], ah
                no_swap:
                dec si
            loop bubble_inner

            pop cx
        loop bubble_outer
        finished_sort:

        popf
        pop si
        pop cx
        pop ax
    ret

; numara cati biti setati are numarul din al (si lasa in al rezultatul)
    popcount:
        push bx
        push cx
        pushf
        
        mov bl, 0
        mov cx, 8
        repeta_popcount:
            shr al, 1
            adc bl, 0
        loop repeta_popcount
        mov al, bl

        popf
        pop cx
        pop bx
    ret


; calculeaza numarul maxim de biti setati
; bh = pozitia in sir, bl = nr. de biti
    max_biti_setati:
        push ax
        push cx
        push si
        pushf

        mov si, offset sir
        cld
        mov ch, 0
        mov cl, l
        mov bx, 0
        repeta_max_biti:
            lodsb
            call popcount
            cmp al, bl
            jbe max_biti_skip
                ; salveaza nr de biti
                mov bl, al
                ; salveaza indexul
                mov bh, l
                sub bh, cl
            max_biti_skip:
        loop repeta_max_biti

        popf
        pop si
        pop cx
        pop ax
    ret

; apeleaza max_biti_setati pentru a gasi pozitia cu numarul maxim de biti setati si apoi afiseaza mesajul de rezultat + endl
    max_biti_setati_plus_afisare:
        pushf
        push bx
        push ax
        push dx

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

        pop dx
        pop ax
        pop bx
        popf

    ret

; afiseaza numarul din al in hexa, urmat de un spatiu
    afisare_al_hex:
        push ax
        push bx
        push cx
        push si
        pushf

        mov ah, 0
        mov bl, 16
        div bl
        mov bx, ax
        mov ah, 02h

        mov ch, 0
        mov cl, bl
        mov si, cx
        mov dl, numtohex[si]
        int 21h

        mov cl, bh
        mov si, cx
        mov dl, numtohex[si]
        int 21h

        mov dl, 'h'
        int 21h

        mov dl, ' '
        int 21h

        popf
        pop si
        pop cx
        pop bx
        pop ax
        
    ret

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

; afiseaza sirul din sir in format hex
    afisare_sir_hex:
        pushf
        push cx
        push si
        
        mov si, offset sir
        cld

        mov cl, l
        mov ch, 0
        jcxz final_afisare_sir_hex

        repeta_afisare_sir_hex:
            lodsb
            call afisare_al_hex
        loop repeta_afisare_sir_hex

        final_afisare_sir_hex:

        pop si
        pop cx
        popf

    ret
;ia sirul de caractere cu offset-ul in ax si il converteste in binar 
 inputToBin:
;la intrare: ax = offset-ul sirului citit de la tastatura (+2)
;se presupune ca in main am mutat in cx lungimea sirului citit 
push bx
push cx
push dx
push si 
push di
mov si, ax 
je fin
mov di, offset binary
repeat:
cmp cx, 0 
je fin
mov al, byte ptr ds:[si]
inc si
dec cx 
mov bl, byte ptr ds:[si]
inc si 
dec cx
cmp al, '9'
ja letter   
sub al, '0'
jmp multiply16
letter:
sub al, 37h
multiply16: 
mov dl, 16
mul dl 
mov temp2, ax
cmp bl, '9'
ja letter2
sub bl, '0' 
jmp addNumbers
letter2:
sub bl, 37h
addNumbers:
mov al, bl 
xor ah, ah 
add temp2, ax 
mov bx, temp2
xor bh, bh
mov byte ptr ds:[di], bl
inc di
jmp repeat
fin: 
pop di 
pop si
pop dx
pop cx
pop bx
ret
; afisarea unui sir in binar
printBin:
;in ax avem offset-ul sirului care trebuie afisat in binar 
;in cx avem lungimea sirului respectiv 
push si 
push bx
mov si, ax 
repeatSeq:
cmp cx, 0 
je finally
mov bl, byte ptr ds:[si]
xor bh, bh
mov counter, 0 
repeatBin:
cmp counter, 8
je next
inc counter
shl bl, 1
jc printOne
mov ah, 02h 
mov dl, '0' 
int 21h 
jmp repeatBin
printOne:
mov ah, 02h
mov dl, '1'
int 21h
jmp repeatBin
next:
inc si 
dec cx
lea dx, mesaj_new_line
mov ah, 09h
int 21h
jmp repeatSeq
finally:
lea dx, mesaj_new_line
mov ah, 09h
int 21h
pop bx
pop si 
ret

start:
    mov ax, data
    mov ds, ax
    mov es, ax
    mov ax, stiva
    mov ss, ax
    mov sp, 1024

; mesaj pentru input
; todo citire
    mov dx, offset mesaj_input
    call afisare_mesaj
    call endl
    mov si, offset input
    lea dx, input 
    mov ah, 0Ah
    int 21h
    call endl
    inc si 
    mov cl, byte ptr ds:[si]
    xor ch, ch
    mov l, cl 
    inc si 
    mov ax,si  
    ;sir de caractere to binary 
    call inputToBin
    mov si, offset binary 
    mov di, offset sir
    mov cl, l
    xor ch, ch
    shr cx, 1
    mov l, cl
    rep movsb 
    
; calcul cuvant C
    call CalculCuvC
    mov dx, offset mesaj_cuvantul_C
    call afisare_mesaj
    call AfisareBaza2

; calculul pozitiei octetului cu cei mai mult biti de 0 (minim 4)
    call max_biti_setati_plus_afisare

; rotirea octetilor
    call Rotiri_s2
    mov dx, offset mesaj_sir_octeti_rotiti
    call afisare_mesaj
    call afisare_sir_hex
    call endl

; sortarea octetilor
    call sort
    mov dx, offset mesaj_sir_sortat
    call afisare_mesaj
    call afisare_sir_hex
    call endl

; afisare sir in binar
   lea dx, mesaj_sir_binar
   mov ah, 09h 
   int 21h
   lea dx, mesaj_new_line
   mov ah, 09h
   int 21h
   mov ax, offset sir 
   mov cl, l
   xor ch, ch 
   call printBin

    mov ax, 4C00h
    int 21h
code ends
end start
