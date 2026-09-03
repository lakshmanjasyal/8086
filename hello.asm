.model small
.stack 100h
.data
;msg db  "Hello, World!" ,0Dh,0Ah, "This is next line.$"
msg db  "Hello, World!" ,0Dh,0Ah,"$"

.code
main proc
mov ax,@data
mov ds,ax

; tells Dos to print string starting address in dx until $

mov ah,09h
lea dx,msg
int 21h

mov ah,4ch 
int 21h

main endp
end main

