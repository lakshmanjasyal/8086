.model small
.stack 100h
.data
prompt1 db "Enter first digit: $"
prompt2 db 0Dh,0Ah,"Enter second digit: $"
result_msg db 0Dh,0Ah,"The sum is: $"
num1 db ?
num2 db ?
sum  db ?

.code
main proc
    mov ax,@data
    mov ds,ax

    ; First digit
    mov ah,09h
    lea dx,prompt1
    int 21h

    mov ah,01h
    int 21h
    sub al,'0'
    mov num1,al

    ; Second digit
    mov ah,09h
    lea dx,prompt2
    int 21h

    mov ah,01h
    int 21h
    sub al,'0'
    mov num2,al

    ; Addition
    mov al,num1
    add al,num2
    mov sum,al

    ; Show result message
    mov ah,09h
    lea dx,result_msg
    int 21h

    ; Print sum (single-digit only)
    mov dl,sum
    add dl,'0'
    mov ah,02h
    int 21h

    ; Exit
    mov ah,4Ch
    int 21h
main endp
end main
