.MODEL SMALL
.STACK 100H 

.DATA 
msg1 db 'Enter your string: $'
msg2 db 0Dh,0Ah,"The length of string is: $"
newline db 0Dh,0Ah,'$'       ; <-- Added newline message

buffer db 20
       db ?
       db 20 dup("$")

.CODE 
MAIN PROC
  mov ax,@data
  mov ds,ax

  ; ---- Ask for input ----
  mov dx,OFFSET msg1
  mov ah,09H
  int 21H

  ; ---- Read string ----
  mov dx , offset buffer
  mov ah,0AH
  int 21H

  ; ---- Print newline before output ----
  lea dx,newline
  mov ah,09h
  int 21h

  ; ---- Print "The length of string is:" ----
  mov dx,OFFSET msg2
  mov ah,09H
  int 21H

  ; ---- Calculate and print string length ----
  mov al,[buffer+1]
  mov ah,0
  mov cx,ax
  CALL PNUM

  ; ---- Exit program ----
  mov ah,4Ch
  int 21h

MAIN ENDP

; ---------------------------------------------------------
; Procedure to print 2-digit number (simple, unchanged)
; ---------------------------------------------------------
PNUM PROC
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
PNUM ENDP

END MAIN
