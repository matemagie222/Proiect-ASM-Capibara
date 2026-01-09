assume CS:code, DS:data

data segment
    
data ends

code segment
start:


    mov ax, 4C00h
    int 21h
code ends
end start
