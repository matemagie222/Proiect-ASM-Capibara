assume cs:code, ds:data
data segment 
binary db 16 dup (?) 
temp dw ? 
message db 'enter 8-16 bytes$'
data ends 
code segment
inputToBin:
;la intrare: ax = offset-ul sirului citit de la tastatura 
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
mov temp, ax
cmp bl, '9'
ja letter2
sub bl, '0' 
jmp addNumbers
letter2:
sub bl, 37h
addNumbers:
mov al, bl 
xor ah, ah 
add temp, ax 
mov bx, temp
xor bh, bh
mov byte ptr ds:[di], bl
inc di
jmp repeat
fin: 
pop bx
pop cx
pop dx 
pop si
pop di
retn
code ends
end start

