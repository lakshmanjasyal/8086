.MODEL SMALL
.STACK 100H

.DATA
prompt_len    DB 'Enter the number of elements (1-9): $'
prompt_array  DB 0DH, 0AH, 'Enter the array elements (followed by spaces): $'
result_msg    DB 0DH, 0AH, 'Sorted Array (Ascending): $'

array_length  DB ?
array_data    DB 9 DUP(0) ; Storage for 9 numerical elements

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; *********************************************************
    ; 1. GET ARRAY LENGTH (N) AND ARRAY ELEMENTS
    ; *********************************************************
    
    ; Get Length N
    MOV AH, 09H
    LEA DX, prompt_len
    INT 21H
    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    MOV [array_length], AL  ; Store length N

    ; Print Prompt and Setup Read Loop
    MOV AH, 09H
    LEA DX, prompt_array
    INT 21H
    MOV DL, 0DH 
    MOV AH, 02H 
    INT 21H
    MOV DL, 0AH 
    INT 21H
    
    ; Setup Loop Counters and Pointers for reading
    MOV SI, OFFSET array_data  ; SI points to start of array storage
    MOV CL, [array_length]     
    MOV CH, 0                  ; CX = N (Outer loop counter)

READ_ARRAY_LOOP:
    ; Input Filtering: Ignore non-digit characters
GET_NEXT_CHAR:
    MOV AH, 01H                
    INT 21H                    
    CMP AL, '0'
    JL GET_NEXT_CHAR           
    CMP AL, '9'
    JG GET_NEXT_CHAR           

    ; Store Valid Digit
    SUB AL, '0'                ; AL = numerical value
    MOV BYTE PTR [SI], AL      
    INC SI
    
    ; Consume Delimiter (Space or Newline)
    MOV AH, 07H                ; Direct Character Input (No Echo)
    INT 21H                    ; Read and discard the space/newline
    
    LOOP READ_ARRAY_LOOP

    ; *********************************************************
    ; 2. BUBBLE SORT ALGORITHM (N-1 passes, N-I comparisons)
    ; *********************************************************
    
    MOV CL, [array_length]     ; Outer loop counter (N)
    DEC CL                     ; Outer loop runs N-1 times
    MOV CH, 0                  ; CX = N-1

OUTER_LOOP: ; Controls the number of passes (N-1)
    PUSH CX                    ; Save OUTER loop counter CX

    ; Inner loop runs N-I times (I is the current outer pass count)
    MOV CL, [array_length]     
    DEC CL                     ; Inner loop runs N-1 times initially
    SUB CL, CH                 ; Reduce inner loop count by outer pass count
    MOV BH, 0                  ; BH=0 (Used for index comparison in inner loop)
    MOV SI, OFFSET array_data  ; SI points to Array[0]
    
INNER_LOOP: ; Controls comparisons and swaps in one pass
    MOV AL, BYTE PTR [SI]      ; AL = Current element (Array[i])
    MOV BL, BYTE PTR [SI + 1]  ; BL = Next element (Array[i+1])
    
    CMP AL, BL                 ; Compare Array[i] and Array[i+1]
    JLE NO_SWAP                ; If AL <= BL, they are in order, skip swap

    ; --- Perform Swap ---
    MOV BYTE PTR [SI], BL      ; Array[i] = Array[i+1] (move smaller value left)
    MOV BYTE PTR [SI + 1], AL  ; Array[i+1] = Array[i] (move larger value right)
    
NO_SWAP:
    INC SI                     ; Move to the next pair (i.e., Array[i+1])
    LOOP INNER_LOOP            ; Decrement CX (inner), continue comparison

    POP CX                     ; Restore OUTER loop counter CX
    LOOP OUTER_LOOP            ; Decrement CX (outer), continue passes

    ; *********************************************************
    ; 3. DISPLAY SORTED ARRAY
    ; *********************************************************
    MOV AH, 09H
    LEA DX, result_msg
    INT 21H
    
    MOV CL, [array_length]     ; CL = Length N
    MOV CH, 0                  ; CX = N
    MOV SI, OFFSET array_data  ; SI points to start of sorted data

PRINT_LOOP:
    MOV DL, BYTE PTR [SI]      ; Load numerical value
    ADD DL, '0'                ; Convert to ASCII character
    MOV AH, 02H                ; Print character
    INT 21H
    
    ; Add a space separator for clear output
    MOV DL, ' '
    MOV AH, 02H
    INT 21H
    
    INC SI                     ; Next element
    LOOP PRINT_LOOP

    ; --- Exit Program ---
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
