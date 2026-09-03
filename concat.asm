.model small
.stack 100h

.data
prompt1 db "Enter first string: $"
prompt2 db 0Dh,0Ah,"Enter second string: $"
result_msg db 0Dh,0Ah,"Concatenated string: $"

buffer1 db 80,?,80 DUP('$')
buffer2 db 80,?,80 DUP('$')

.code 
main proc
mov ax,@data
mov ds,ax

mov ah,09h
lea dx,prompt1
int 21h

mov ah,0Ah
lea dx,buffer1
int 21h

mov ah,09h
lea dx,prompt2
int 21h

mov ah,0Ah
lea dx,buffer2
int 21h

; Prepare string 1 for concatenation

mov al,BYTE PTR[buffer1+1]
mov ah,0
mov si,ax
add si,OFFSET buffer1+2
mov BYTE PTR[si],'$'

mov ah,09h
lea dx,result_msg
int 21h

mov ah,09h
lea dx,buffer1+2
int 21h

mov ah,09h
lea dx,buffer2+2
int 21h

mov ah,4Ch
int 21h

main endp
end main
