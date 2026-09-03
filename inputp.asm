.model small
.stack 100h 
.data 
msg1 db 'Enter first digit: $'
msg2 db 0Dh,0Ah,'Enter second digit: $'
newline db 0Dh,0Ah,'$'
msg3 db 0Dh,0Ah,'The sum is: $'
num1 dw ?
num2 dw ?
num3 dw ?
.code 
main proc
mov ax,@data
mov ds,ax 

mov ah,09H
lea dx,msg1
int 21h 
call p2num
mov num1,ax


mov ah,09H
lea dx,msg2
int 21h 
call p2num
mov num2,ax

mov ah,09H 
lea dx,newline 
int 21h 

mov ax,num1
add ax,num2
mov num3,ax

mov ah,09H
lea dx,msg3
int 21h 
mov ax,num3

call Printnum

lea dx,newline
mov ah,09h 
int 21h 
mov ah,4ch 
int 21h 

main endp


p2num proc 

push ax 
xor ax,ax 
mov bx,10 

mov ah,01H
int 21H
sub al,'0'
push ax 

xor ah,ah 
mul bx
pop bx 
push ax 

mov ah,01h 
int 21h 
sub al,'0'
xor ah,ah 

pop bx 
add ax,bx 
pop bx 
ret 

p2num endp 


Printnum proc 

; mov ah,0 
; mov bh,0
; mov bl,10 
; div bl 

; mov bh,ah 
; cmp al,0
; je single_digit
; add al,'0'
; mov dl,al
; mov ah,02H
; int 21H

; single_digit:
; add bh,'0'
; mov dl,bh
; mov ah,02h 
; int 21h 
; ret 

push ax 
push bx 
push cx 
push dx 
mov cx,0 
mov bx,10 
cmp ax,0 
jne pn_loop 
mov dl,'0'
mov ah,02h 
int 21h 
jmp pn_done 

pn_loop:
mov dx,0
div bx 
push dx 
inc cx 
cmp ax,0
jne pn_loop 

pn_print: 
pop dx 
add dl,'0'
mov ah,02h 
int 21h 
loop pn_print 

pn_done: 
pop dx 
pop cx 
pop bx 
pop ax 
ret 

Printnum endp
end main 
