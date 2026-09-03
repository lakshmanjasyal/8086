.model small
.stack 100H
.data
msg1 db 'Enter first number: $'
msg2 db 0Ah,0Dh,'Enter second number: $'

num1 dw ?
num2 dw ?
num3 dw ?

.code
main proc
mov ax,@data
mov ds,ax 

mov ah,09H
lea dx,msg1
int 21H
call Read2Digit
mov num1,ax 


mov ah,09h 
lea dx,msg2
int 21H
call Read2Digit
mov num2,ax 

mov ax,num1
mov bx,num2 
add ax,bx
mov num3,ax 



call PrintNumber


mov ah,4ch 
int 21h 

main endp 

Read2Digit proc

push bx 
xor ax,ax 
mov bx,10 

mov ah,01h 
int 21H
sub al,'0'
push ax ; read number and stored ,pushed in bx like 0005h

xor ah,ah 
mul bx 
pop bx ; take out 0005 from stack
push ax ; pushed 0050 into the bx

mov ah,01h 
int 21h 
sub al,'0'
xor ah,ah 

pop bx 
add ax,bx 
pop bx
ret 
Read2Digit endp 


PrintNumber proc
; push ax 
; mov bl,10
; div bl 
; ; al---> tens place (so print first). ah---> ones place (last place)
; mov dl,al
; add dl,'0'
; mov ah,02h 
; int 21h 
; ; printed 10th place

; mov dl,ah 
; add dl,'0'
; mov ah,02h 
; int 21h 
; pop ax 
; ret 

;    push ax
;     mov bx,100
;     xor dx,dx
;     div bx          ; AX / 100 → AL = hundreds, DX = remainder

;     mov dl,al
;     add dl,'0'      ; Hundreds
;     mov ah,2
;     int 21h

;     mov ax,dx
;     mov bl,10
;     xor ah,ah
;     div bl          ; Divide remainder by 10 → AL = tens, AH = ones

;     mov dl,al
;     add dl,'0'      ; Tens
;     mov ah,2
;     int 21h

;     mov dl,ah
;     add dl,'0'      ; Ones
;     mov ah,2
;     int 21h

;     pop ax
;     ret


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
PrintNumber endp

end main 
