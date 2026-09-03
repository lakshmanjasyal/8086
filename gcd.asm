.MODEL SMALL
.STACK 100H
.DATA
msg1 DB 'Enter first 2-digit number: $'
msg2 DB 0DH,0AH,'Enter second 2-digit number: $'
msg3 DB 0DH,0AH,'GCD: $'
msg4 DB 0DH,0AH,'LCM: $'
newline DB 0DH,0AH,'$'

num1 DW ?
num2 DW ?
gcd  DW ?
lcm  DW ?

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    ; -------- Input First Number --------
    LEA DX,msg1
    MOV AH,9
    INT 21H
    CALL Read2Digit
    MOV num1,AX

    ; -------- Input Second Number --------
    LEA DX,msg2
    MOV AH,9
    INT 21H
    CALL Read2Digit
    MOV num2,AX

    ; -------- Calculate GCD using Euclid Algorithm --------
    MOV AX,num1
    MOV BX,num2

GCD_LOOP:
    CMP BX,0
    JE DONE_GCD         ; if BX = 0, GCD = AX
    MOV DX,0
    DIV BX              ; AX / BX → quotient in AX, remainder in DX
    MOV AX,BX           ; set AX = BX
    MOV BX,DX           ; set BX = remainder
    JMP GCD_LOOP

DONE_GCD:
    MOV gcd,AX          ; store GCD

    ; -------- Calculate LCM = (num1 * num2) / gcd --------
    MOV AX,num1
    MUL num2            ; AX = num1 * num2
    MOV BX,gcd
    DIV BX              ; AX = LCM
    MOV lcm,AX

    ; -------- Display Results --------
    LEA DX,msg3
    MOV AH,9
    INT 21H
    MOV AX,gcd
    CALL PrintNumber

    LEA DX,msg4
    MOV AH,9
    INT 21H
    MOV AX,lcm
    CALL PrintNumber

    LEA DX,newline
    MOV AH,9
    INT 21H

    ; -------- Exit Program --------
    MOV AH,4CH
    INT 21H
MAIN ENDP

; ======================================================
; === Read two-digit number (like 35) from keyboard ====
; ======================================================
Read2Digit PROC
    PUSH BX
    XOR AX,AX
    MOV BX,10

    ; --- Read first digit (tens) ---
    MOV AH,1
    INT 21H
    SUB AL,'0'
    MUL BX              ; AX = tens * 10
    MOV BL,AL           ; store result temporarily in BL

    ; --- Read second digit (ones) ---
    MOV AH,1
    INT 21H
    SUB AL,'0'
    ADD AL,BL           ; add tens*10 + ones
    MOV AH,0            ; ensure AX = full number (word)
    POP BX
    RET
Read2Digit ENDP

; ======================================================
; === Print number in AX (up to 5 digits) ==============
; ======================================================
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
 