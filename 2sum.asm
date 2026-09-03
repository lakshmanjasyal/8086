.MODEL SMALL
.STACK 100H

.DATA
msg1    DB 'Enter first 2-digit number: $'
msg2    DB 0DH,0AH,'Enter second 2-digit number: $'
msg4    DB 0DH,0AH,'Result (Sum): $'
newline DB 0DH,0AH,'$'

num1    DW ?
num2    DW ?
result  DW ?

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    ; ---- Input first number ----
    LEA DX,msg1
    MOV AH,09h
    INT 21H
    CALL Read2Digit
    MOV num1,AX

    ; ---- Input second number ----
    LEA DX,msg2
    MOV AH,9
    INT 21H
    CALL Read2Digit
    MOV num2,AX

    ; ---- Perform Addition ----
    MOV AX,num1
    ADD AX,num2
    
    ; The result (up to 198) is in AX, store it.
    MOV result,AX

    ; ---- Print result ----
    LEA DX,msg4
    MOV AH,9
    INT 21H
    MOV AX,result
    CALL PrintNumber

DONE:
    LEA DX,newline
    MOV AH,9
    INT 21H

    MOV AH,4CH
    INT 21H
MAIN ENDP


; ----------------------------------------------------------------
; Read two digits (Tens and Ones) and calculate the 16-bit value.
; Result is returned in AX.
; ----------------------------------------------------------------
Read2Digit PROC
    PUSH BX
    
    XOR AX,AX
    MOV BX,10

    ; --- 1. Read First Digit (Tens) ---
    MOV AH,01h
    INT 21H
    SUB AL,'0'          ; AL = Tens digit (e.g., 5)
    
    PUSH AX             ; Save the Tens digit (5)
    
    ; Multiply Tens digit by 10
    XOR AH,AH           ; AX = 0005h
    MUL BX              ; AX = 5 * 10 = 50 (Tens Place Value)
    
    POP BX              ; BX = Tens digit (5) (We don't need this, but we pop to balance the stack)
    PUSH AX             ; Save the calculated Tens Place Value (50)
    
    ; --- 2. Read Second Digit (Ones) ---
    MOV AH,1
    INT 21H
    SUB AL,'0'          ; AL = Ones digit (e.g., 3)
    XOR AH,AH           ; AX = Ones digit (0003h)
    
    POP BX              ; BX = Tens Place Value (50)
    
    ; Add the two values: AX = 3 + 50 = 53
    ADD AX,BX           ; AX now holds the full 16-bit number (53)

    POP BX              ; Restore BX (Original)
    RET
Read2Digit ENDP


; ----------------------------------------------------------------
; PrintNumber PROC is correct and handles up to 5 digits (16-bit)
; ----------------------------------------------------------------
PrintNumber PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    XOR CX,CX
    MOV BX,10
    CMP AX,0
    JNE PN_LOOP
    MOV DL,'0'
    MOV AH,2
    INT 21H
    JMP PN_DONE

PN_LOOP:
    XOR DX,DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX,0
    JNE PN_LOOP

PN_PRINT:
    POP DX
    ADD DL,'0'
    MOV AH,2
    INT 21H
    LOOP PN_PRINT

PN_DONE:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintNumber ENDP

END MAIN
