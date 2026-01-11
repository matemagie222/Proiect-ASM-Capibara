assume CS:code, DS:data

data segment
    sir db 0AAh, 91h, 28h, 35h, 0B9h, 5Ch, 0FFh, 02h, 10h, 20h
    l dw 10    


    mesaj_input db "Introduceti 8-16 octeti in format hexa: $"
    mesaj_input_fail db "Nu ati introdus un numar corect de octeti$"
    mesaj_biti_setati_max db "Numarul cu cei mai multi biti de 1 este: $"
    mesaj_biti_setati_fail db "Niciun numar nu are cel putin 4 biti de 1 setati$"
    mesaj_sir_octeti_rotiti db "Sirul dupa rotirea octetilor este: $"
    mesaj_sir_sortat db "Sirul dupa sortare este: $"
    mesaj_cuvantul_C db "Cuvantul C este: $"

    mesaj_new_line db 0Dh, 0Ah, '$'

data ends

stiva segment stack
    db 512 dup (?)
stiva ends

code segment
; afiseaza mesajul al carui offset este in dx
    afisare:
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

; sorteaza sirul din "sir" cu lungimea "l"
    sort:
        push ax
        push cx
        push si
        pushf

        mov cx, l
        jcxz finished_sort
        dec cx
        jcxz finished_sort
        bubble_outer:
            push cx
            mov cx, l
            dec cx
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

start:
    mov ax, data
    mov ds, ax

; mesaj pentru input
    mov dx, offset mesaj_input
    call afisare
    call endl
    call pauza

; todo citire
; todo conversie, cuvantul C etc.

    call sort
        

    mov ax, 4C00h
    int 21h
code ends
end start
