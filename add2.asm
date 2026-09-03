.model small
.stack 100h
.data
prompt1 db "Enter first digit: $"
prompt2 db 0Dh,0Ah, "Enter second digit: $"
result_msg db 0Dh,0Ah, "The sum is: $"
num1 db ?
num2 db ?
sum db ?
quotient db ?
remainder db ?


.code
main proc 

mov ax,@data
mov ds, ax

mov ah,09h
lea dx,prompt1
int 21h

mov ah,01h
int 21h
sub al,'0'
mov num1,al

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

; Print message result
mov ah,09h
lea dx,result_msg
int 21h

; Convert sum to decimal
mov ax,0
mov al,sum
mov bl,10
div bl
mov quotient,al
mov remainder,ah

; Print tens digit
cmp quotient,0
je print_units

add quotient,'0'
mov dl,quotient
mov ah,02h
int 21h

print_units:
add remainder,'0'
mov dl,remainder
mov ah,02h
int 21h

mov ah,4Ch
int 21h

main endp
end main

