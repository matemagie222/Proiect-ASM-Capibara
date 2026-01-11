;CUVANTUL C

assume cs: code, ds: data
data segment
sir db 12h, 34h, 56h, 78h, 90h, 0ABh, 0CDh, 0EFh
len equ $-sir
sir2 db len dup(?)
temp db ?
rez dw ?
data ends
code segment
start:

mov ax, data
mov ds, ax

; ---- Calcularea bitilor 0-3 pentru cuvantul c: 0000 0000 0000 xxxx ----
mov al, sir[0]
mov cl,4
shr al,cl
; --al = 0000xxxx

mov si, len
dec si
mov bl, sir[si]
and bl, 00001111b
xor al, bl

; --al=0000xxxx octetul cerut stocat in AL


;---- Calculul bitilor 4-7 din cuvantul c:  0000 0000 xxxx 0000 ----
mov cx, len
mov si, 0
mov temp, 0

repeta:
mov bl, sir[si]
and bl, 00111100b
or temp, bl
inc si
loop repeta
;-- temp = 00xxxx00 contine bitii 4-7 

mov cl, 2
shl temp, cl
;-- temp = xxxx0000 pentru a putea face or cu AL ca sa obtinem intregul octet 0-7

or al, temp
;-- al = xxxx xxxx

mov ah, 0
mov rez,ax

;-- rez = 0000 0000 xxxx xxxx

;---- Calculul bitilor 10-15 : xxxx xxxx 0000 0000 ----
mov cx,len
mov si,0
mov bx,0

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


; ROTIRILE
mov cx, len
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
mov sir2[si], al

pop cx ; scot valoarea lui cx din stiva pentru a nu afecta loopul cand modific cl
inc si

loop rot

mov ax, 4c00h
int 21h
code ends
end start

