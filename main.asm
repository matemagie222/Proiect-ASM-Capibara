assume CS:code, DS:data

data segment
    sir db 0AAh, 91h, 28h, 35h, 0B9h, 5Ch, 0FFh, 02h, 10h, 20h
    l db 10    


    mesaj_input db "Introduceti 8-16 octeti in format hexa: aaaaaa$"
    mesaj_input_fail db "Nu ati introdus un numar corect de octeti$"
    mesaj_biti_setati_max db "Numarul cu cei mai multi biti de 1 este: $"
    mesaj_biti_setati_fail db "Niciun numar nu are cel putin 4 biti de 1 setati$"
    mesaj_sir_octeti_rotiti db "Sirul dupa rotirea octetilor este: $"
    mesaj_sir_sortat db "Sirul dupa sortare este: $"
    mesaj_cuvantul_C db "Cuvantul C este: $"

    mesaj_new_line db "\n\r$"

data ends

stiva segment stack
    db 512 dup (?)
stiva ends

code segment
; afiseaza mesajul al carui offset este in ax
afisare:
    mov ah, 09h
    int 21h
    ret

endl:
    mov ax, offset mesaj_new_line
    mov ah, 09h
    int 21h
    ret

start:
    mov ax, data
    mov ds, ax

    mov ax, offset mesaj_input
    call afisare
    call endl



    mov ax, 4C00h
    int 21h
code ends
end start
