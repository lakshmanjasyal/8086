; .model small
; .stack 100h
; .data
; message DB "Hello, 8086!$"

; .code
; main proc
;     mov ax, @data
;     mov ds, ax

;     ; --- 1. Clear the Screen (INT 10h, AH=06h) ---
;     ; This function scrolls a window, and by defining the entire screen
;     ; as the window and setting AL=0, it clears the whole screen.
;     mov ah, 06h      ; Function: Scroll window up
;     mov al, 00h      ; AL=0 means clear the entire window
;     mov ch, 00h      ; CH = Top row (0)
;     mov cl, 00h      ; CL = Left column (0)
;     mov dh, 24h      ; DH = Bottom row (24h = 36 decimal, usually 24 for 80x25 screen)
;     mov dl, 79h      ; DL = Right column (79h = 121 decimal, usually 79 for 80 columns)
;     mov bh, 07h      ; BH = Attribute (07h = light gray on black)
;     int 10h          ; Execute video interrupt

;     ; --- 2. Set Cursor Position (INT 10h, AH=02h) ---
;     ; Standard 80x25 screen is 0-79 columns and 0-24 rows.
;     ; "Hello, 8086!" is 14 characters long.
;     ; Center Row (approx 12), Center Column (approx 80/2 - 14/2 = 40 - 7 = 33)
;     mov ah, 02h      ; Function: Set cursor position
;     mov bh, 00h      ; BH = Page number (0)
;     mov dh, 12       ; DH = Row (12)
;     mov dl, 33       ; DL = Column (33)
;     int 10h          ; Execute video interrupt

;     ; --- 3. Display Message (INT 21h, AH=09h) ---
;     ; We use the familiar DOS interrupt to print the string
;     mov ah, 09h
;     lea dx, message
;     int 21h

;     ; --- 4. Exit Program ---
;     mov ah, 4ch
;     int 21h
; main endp
; end main



.model small
.stack 100H
.data
msg db "Hello, 8086!$"

.code
main proc
mov ax,@data
mov ds,ax

mov ah,06h
mov al,00h
mov ch,00h
mov cl,00h
mov dh,24h
mov dl,79h
mov bh,07h
int 10h 

mov ah,02h
mov bh,00h
mov dh,12
mov dl,33
int 10H

mov ah,09H
lea dx,msg
int 21H

mov ah,4ch
int 21H
main endp
end main
