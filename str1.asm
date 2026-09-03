.model small
.stack 100h 
.data
msg1 db 'Enter string: $'
msg2 db 0Dh,0Ah,'The length of string is: $'
newline db 0Dh,0Ah,'$'

buffer db 20
        db ?
        db 20 dup("20")

.code 
main proc 

mov ax,@data
mov ds,ax 

mov ah,09H
lea dx,msg1 
int 21h 

; read input
mov ah,0Ah 
lea dx,buffer 
int 21h 

; print newline 
mov ah,09h 
lea dx,newline 
int 21h 


mov ah,09h ; The length of string is:
lea dx,msg2 
int 21h 

mov al,[buffer+1]
xor ah,ah 
mov cx,ax 
call p_num

mov ah,4ch
int 21H
main endp 

p_num proc 
 mov ah,0
 mov bh,0
 mov bl,10
 div bl
 mov bh,ah
 cmp al,0
 je only_ones
 add al,30h

 mov dl,al
 mov ah,02H
 int 21H

only_ones:
 add bh,30h 
 mov dl,bh
 mov ah,02H
 int 21H
 ret
p_num endp 

end main 


