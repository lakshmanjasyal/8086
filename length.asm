; .model small
; .stack 100h
; .data
; prompt    DB "Enter a string (max 80 chars): $"
; msg_len   DB 0Dh, 0Ah, "The length is: $"
; buffer    DB 80        ; Max length allowed (80)
; actual_len DB ?         ; DOS stores the actual length here
; input_str DB 80 DUP('$') ; Buffer for the string itself

; .code
; main proc
;     mov ax, @data
;     mov ds, ax

;     ; --- 1. Get String Input ---
;     mov ah, 09h
;     lea dx, prompt
;     int 21h

;     mov ah, 0Ah          ; Buffered input function
;     lea dx, buffer       ; Load address of the buffer
;     int 21h

;     ; --- 2. Display Length Message ---
;     mov ah, 09h
;     lea dx, msg_len
;     int 21h

;     ; --- 3. Get Length and Convert/Print ---
;     mov al, [buffer+1]   ; AL = Actual length (a number, e.g., 5)
    
;     ; Convert the number in AL to a printable ASCII digit
;     mov ah, 0            ; Clear AH
;     mov bl, 10           ; Divisor (10)
;     div bl               ; AL=Quotient (Tens), AH=Remainder (Ones)
    
;     ; Print Tens Digit (If > 9, required for two-digit output)
;     cmp al, 0
;     je print_ones        ; If tens digit is 0, skip printing it
;     add al, '0'
;     mov dl, al
;     mov ah, 02h
;     int 21h

; print_ones:
;     ; Print Ones Digit
;     mov al, ah           ; AL = Remainder (Ones digit)
;     add al, '0'
;     mov dl, al
;     mov ah, 02h
;     int 21h

;     ; --- 4. Exit ---
;     mov ah, 4Ch
;     int 21h
; main endp
; end main



























.model small
.stack 100h

.data
prompt1 db "Enter the string: $"
msg_len db 0Dh,0Ah,"The length of string: $"
buffer db 80
input_str DB 80 DUP('$')

.code 
main proc

mov ax,@data
mov ds,ax

mov ah,09h
lea dx,prompt1
int 21h

mov ah,0Ah
lea dx,buffer
int 21h

mov ah,09h
lea dx,msg_len
int 21h


mov al,[buffer+1]
; printable ascii.  
mov ah,0
mov bl,10
div bl

cmp al,0
je print_ones
add al,'0'
mov dl,al
mov ah,02h
int 21h

print_ones:
mov al,ah
add al,'0'
mov dl,al
mov ah,02h
int 21h

mov ah,4Ch
int 21h


main endp
end main