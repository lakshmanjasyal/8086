.model small
.stack 100h
.data
prompt1 DB "Enter the larger digit: $"
prompt2 DB 0Dh, 0Ah, "Enter the smaller digit: $"
result_msg DB 0Dh, 0Ah, "The difference is: $"
num1_val DB ?
num2_val DB ?

.code
main proc
    mov ax, @data
    mov ds, ax

    ; --- 1. Get First Number (Minuend) ---
    mov ah, 09h         ; Display string function
    lea dx, prompt1
    int 21h
    mov ah, 01h         ; Read character function
    int 21h
    sub al, '0'         ; Convert ASCII to number
    mov num1_val, al    ; Store first number

    ; --- 2. Get Second Number (Subtrahend) ---
    mov ah, 09h
    lea dx, prompt2
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'         ; Convert ASCII to number
    mov num2_val, al    ; Store second number

    ; --- 3. Perform Subtraction ---
    mov al, num1_val    ; AL = Larger number
    sub al, num2_val    ; AL = AL - Smaller number (Result is in AL)

    ; --- 4. Display Result Message ---
    mov ah, 09h
    lea dx, result_msg
    int 21h

    ; --- 5. Print Decimal Result ---
    add al, '0'         ; Convert the numerical result back to ASCII character
    mov dl, al          ; Move character to DL for output
    mov ah, 02h         ; Display character function
    int 21h

    ; --- 6. Exit Program ---
    mov ah, 4ch
    int 21h
main endp
end main