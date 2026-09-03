.model small
.stack 100h
.data 
prompt1 db 'Enter the first digit:$'
prompt2 db 0ah,0dh,'Enter the second digit:$'
msg_result db 0ah,0dh,'The sum is:$'
.code
main proc 
mov ax,@data
mov ds,ax
mov dx,offset prompt1
mov ah,9
int 21h
;first
mov ah,1
int 21h
sub al,'0'
mov bl,al
;2nd
mov ah,9
mov dx,offset prompt2
int 21h
mov ah,1
int 21h
sub al,'0'

;add
add bl,al
mov al,bl

mov ah,9
mov dx,offset msg_result
int 21h

;print sum
mov ah,0
call print_dec
mov ah,4ch
int 21h
main endp

print_dec proc
mov bx,10
mov cx,0
L1:
 mov dx,0
 div bx
 push dx
 inc cx
 cmp ax,0
 jne L1
 
L2: 
 pop dx
 add dl,'0'
 mov ah,2
 int 21h
 loop L2
 ret
print_dec endp
 
end main





