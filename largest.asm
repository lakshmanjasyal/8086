.MODEL SMALL
.STACK 100H

.DATA
prompt_len    DB 'Enter the number of elements (1-9): $'
prompt_array  DB 0DH, 0AH, 'Enter the array elements (as a single string): $'
result_msg    DB 0DH, 0AH, 'The largest number is: $'

; Buffer for length input (AH=01h)
array_length  DB ?

; Array data storage (Max 9 single digits)
array_data    DB 9 DUP(0) 

largest_val   DB ?         ; Storage for the largest number found

.CODE
MAIN PROC
    MOV AX, @DATA               ; Load the address of the data segment into AX
    MOV DS, AX                  ; Initialize the Data Segment register (DS)

    ; *********************************************************
    ; ---- 1. GET ARRAY LENGTH (N) ----
    ; *********************************************************
    MOV AH, 09H                 ; Function 09h: Display string
    LEA DX, prompt_len          ; Load address of the length prompt
    INT 21H                     ; Execute interrupt (Prints "Enter the number...")
    
    MOV AH, 01H                 ; Function 01h: Read single character input (with echo)
    INT 21H                     ; Execute interrupt (Reads length N as ASCII)
    SUB AL, '0'                 ; Convert ASCII digit (e.g., '5') to number (5)
    
    MOV [array_length], AL      ; Store numerical length N in memory
    MOV CL, AL                  ; Move length N to CL (low part of loop counter)
    MOV CH, 0                   ; Clear CH (high part) so CX = N

    ; *********************************************************
    ; ---- 2. GET ARRAY ELEMENTS & CONVERT (One by One) ----
    ; *********************************************************
    MOV AH, 09H                 ; Function 09h: Display string
    LEA DX, prompt_array        ; Load address of the array prompt
    INT 21H                     ; Execute interrupt (Prints "Enter the array...")
    
    ; Move cursor to next line after the prompt
    MOV DL, 0DH                 ; DL = Carriage Return (move cursor to start of line)
    MOV AH, 02H                 ; Function 02h: Display character
    INT 21H
    MOV DL, 0AH                 ; DL = Line Feed (move cursor down one line)
    INT 21H                     ; (Prints the actual newline)
    
    MOV SI, OFFSET array_data   ; SI (Source Index) points to the start of where we store numbers
    
    MOV BL, [array_length]      ; BL = Length N (used temporarily to reset CX later)
    MOV CH, 0                   ; Clear CH
    MOV CL, BL                  ; CX = N (Reset loop counter for reading array)

READ_ARRAY_LOOP:
    MOV AH, 01H                 ; Function 01h: Read single character
    INT 21H                     ; Reads the next digit (e.g., '1')
    SUB AL, '0'                 ; Convert ASCII digit to its numerical value (e.g., 1)
    MOV BYTE PTR [SI], AL       ; Store the numerical value into the array location pointed to by SI
    INC SI                      ; Increment SI to point to the next byte/element in the array
    LOOP READ_ARRAY_LOOP        ; Decrement CX and jump back to READ_ARRAY_LOOP if CX > 0

    ; *********************************************************
    ; ---- 3. FIND THE LARGEST NUMBER ----
    ; *********************************************************
    
    MOV BL, [array_length]      ; BL = Length N
    MOV CL, BL                  ; Set CL = N
    MOV CH, 0                   ; CX = N (Main loop counter for iteration)
    
    MOV SI, OFFSET array_data   ; SI points back to the first element (index 0)
    MOV AL, BYTE PTR [SI]       ; Load the first element into AL
    MOV [largest_val], AL       ; Store initial largest value (our starting comparison point)
    
    INC SI                      ; Move SI to the second element (index 1)
    DEC CX                      ; Decrement CX because the first element was already handled (CX = N - 1)

LOOP_FIND_LARGEST:
    MOV AL, BYTE PTR [SI]       ; Load the current element (at SI) into AL
    CMP AL, [largest_val]       ; Compare the current element (AL) with the largest found so far
    JLE NEXT_ELEMENT            ; Jump if AL is Less than or Equal (JLE) to the largest_val
    
    MOV [largest_val], AL       ; If current element is larger, update largest_val
    
NEXT_ELEMENT:
    INC SI                      ; Move SI to the next array element
    LOOP LOOP_FIND_LARGEST      ; Decrement CX and jump back to LOOP_FIND_LARGEST if CX > 0
    
    ; *********************************************************
    ; ---- 4. DISPLAY RESULT ----
    ; *********************************************************
    MOV AH, 09H                 ; Function 09h: Display string
    LEA DX, result_msg          ; Load address of the result message
    INT 21H                     ; Execute interrupt (Prints "The largest number is: ")
    
    MOV DL, [largest_val]       ; Load the final numerical result (e.g., 9) into DL
    ADD DL, '0'                 ; Convert numerical result (9) to ASCII character ('9')
    MOV AH, 02H                 ; Function 02h: Display character
    INT 21H                     ; Execute interrupt (Prints the largest number)

    ; --- Exit Program ---
    MOV AH, 4CH                 ; Function 4Ch: Terminate program
    INT 21H                     ; Execute interrupt
MAIN ENDP
END MAIN