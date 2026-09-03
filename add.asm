.model small
.stack 100h
.data
prompt1 db "Enter first single digit number: $"
prompt2 db 0Dh, 0Ah, "Enter the second single digit number: $"
result_msg db 0Dh, 0Ah, "The sum is: $"
num1_val db ?
num2_val db ?
sum_val db ?  ; Max sum is 18 (fits in one byte)

.code
main proc
  mov ax, @data
  mov ds, ax

  ; --- Get First Number ---
  mov ah, 09h
  lea dx, prompt1
  int 21h
  mov ah, 01h
  int 21h
  sub al, '0'
  mov num1_val, al

  ; --- Get Second Number ---
  mov ah, 09h
  lea dx, prompt2
  int 21h
  mov ah, 01h
  int 21h
  sub al, '0'
  mov num2_val, al

  ; --- Perform Addition ---
  mov al, num1_val
  add al, num2_val
  mov sum_val, al     ; Store the result

  ; --- Display Result Message ---
  mov ah, 09h
  lea dx, result_msg
  int 21h

  ; --- Print Decimal Sum ---
  mov ah, 0           ; <--- CRITICAL FIX: Ensure AH is zero before loading AL
  mov al, sum_val     ; Load sum into AL (and AH is now 0)
  call print_decimal

  ; --- Exit Program ---
  mov ah, 4ch
  int 21h
main endp

; ----------------------------------------------------------------
; Procedure to convert and print a number (up to 2 digits) in AX
; ----------------------------------------------------------------
print_decimal proc
  push ax
  push bx
  push cx
  push dx
  
  mov cx, 0           ; Initialize digit counter
  mov bx, 10          ; Divisor for base 10 conversion
  
divide_loop:
  xor dx, dx          ; Clear DX
  div bx              ; Divide AX by 10 (quotient in AX, remainder in DX)
  push dx             ; Push remainder (digit) onto stack
  inc cx              ; Increment digit counter
  cmp ax, 0           ; Check if quotient is zero
  jnz divide_loop     ; If not, loop again

print_loop:
  pop dx              ; Pop digit from stack
  add dl, '0'         ; Convert digit to ASCII character
  mov ah, 02h         ; Display character function
  int 21h             ; Print the digit
  loop print_loop     ; Loop until all digits are printed
  
  pop dx
  pop cx
  pop bx
  pop ax
  ret
print_decimal endp

end main