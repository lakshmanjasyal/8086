.MODEL SMALL
.STACK 100H
.DATA
msg1 DB 'Enter number of terms (1-digit): $'
msg2 DB 0DH,0AH,'Fibonacci Series:$'
newline DB 0DH,0AH,'$'

num DW ?
a DW 0
b DW 1
c DW ?

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    ; --- Input N ---
    LEA DX,msg1
    MOV AH,9
    INT 21H
    CALL Read1Digit
    MOV num,AX

    ; --- Print Heading ---
    LEA DX,msg2
    MOV AH,9
    INT 21H

    ; --- Print first two terms ---
    MOV CX,num
    CMP CX,1
    JL EXIT

    MOV AX,a
    CALL PrintNumber
    LEA DX,newline
    MOV AH,9
    INT 21H

    CMP CX,1
    JE EXIT

    MOV AX,b
    CALL PrintNumber
    LEA DX,newline
    MOV AH,9
    INT 21H

    SUB CX,2

FIB_LOOP:
    MOV AX,a
    ADD AX,b
    MOV c,AX
    MOV AX,c
    CALL PrintNumber
    LEA DX,newline
    MOV AH,9
    INT 21H

    MOV AX,b
    MOV a,AX
    MOV AX,c
    MOV b,AX
    LOOP FIB_LOOP

EXIT:
    MOV AH,4CH
    INT 21H
MAIN ENDP


;---------------------------
; Read1Digit: single ASCII → number
;---------------------------
Read1Digit PROC
    MOV AH,1        ; read char
    INT 21H
    SUB AL,'0'      ; convert ASCII → number
    XOR AH,AH
    RET
Read1Digit ENDP


;---------------------------
; PrintNumber: prints up to 5 digits
;---------------------------
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
