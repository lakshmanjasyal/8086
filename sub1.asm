.model small
.stack 100h
.data
prompt1     db "Enter first digit: $"
prompt2     db 0Dh,0Ah,"Enter second digit: $"
result_msg  db 0Dh,0Ah,"The difference is: $"
num1        db ?
num2        db ?
diff        db ?

; New/Modified data definitions for robust output
minus_sign  db "-", "$" ; String for just the minus sign
digit_output db ?, "$" ; Placeholder for the magnitude digit (e.g., '1')

.code
main proc
    mov ax,@data
    mov ds,ax

    ; ---- Get First digit (Minuend) ----
    mov ah,09h
    lea dx,prompt1
    int 21h

    mov ah,01h
    int 21h
    sub al,'0'
    mov num1,al

    ; ---- Get Second digit (Subtrahend) ----
    mov ah,09h
    lea dx,prompt2
    int 21h

    mov ah,01h
    int 21h
    sub al,'0'
    mov num2,al

    ; ---- Subtraction ----
    mov al,num1
    sub al,num2     ; difference = num1 - num2
    mov diff,al

    ; ---- Print result message ----
    mov ah,09h
    lea dx,result_msg
    int 21h

    ; ---- Check for Negative Result (Result is in AL) ----
    cmp al, 0
    jge print_positive ; If AL >= 0, skip negative handling

    ; ---- Handle negative difference (Negative Path) ----
    neg al                         ; Make AL positive (e.g., -2 becomes 2)
    call print_negative_string     ; Go print '-' and the magnitude
    jmp program_exit               ; Skip positive printing

print_positive:
    ; --- Convert magnitude to ASCII and print (Positive Path) ---
    add al,'0'                     ; Convert number (0-9) to ASCII ('0'-'9')
    mov dl,al                      ; Move ASCII character to DL
    mov ah,02h                     ; Use standard function 02h for single char
    int 21h                        ; Print the magnitude (e.g., '2' or '1')


    ; ---- Exit ----
program_exit:
    mov ah,4Ch
    int 21h
main endp

; ----------------------------------------------------------------
; Procedure to print the negative sign followed by the magnitude digit
; AX must contain the POSITIVE magnitude (e.g., 1 for -1)
; ----------------------------------------------------------------
print_negative_string proc
    push ax
    push dx

    ; 1. Print the "-" sign (using AH=09h string function)
    mov ah, 09h
    lea dx, minus_sign
    int 21h

    ; 2. Prepare and print the magnitude (e.g., '1')
    mov [digit_output], al ; Store the magnitude (e.g., 1) in the digit placeholder
    add BYTE PTR [digit_output], '0' ; Convert the stored number to ASCII

    mov ah, 09h
    lea dx, digit_output
    int 21h

    pop dx
    pop ax
    ret
print_negative_string endp

end main
