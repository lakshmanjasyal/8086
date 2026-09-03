.MODEL SMALL
.STACK 100H

.DATA
msg_start   DB 'Current System Date: $'
date_separator DB '/', '$' ; Separator character

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- 1. Display Message ---
    MOV AH, 09H
    LEA DX, msg_start
    INT 21H

    ; --- 2. Get System Date ---
    MOV AH, 2AH      ; Function 2Ah: Get Date
    INT 21H          ; Returns: CX = Year, DH = Month, DL = Day

    ; --- 3. Print Day (DL) ---
    MOV AL, DL       ; Day is in DL
    MOV AH, 0        ; Clear AH (AX = Day)
    CALL PrintNumber ; Prints the day (e.g., 07)

    ; --- 4. Print Separator (/) ---
    MOV AH, 09H
    LEA DX, date_separator
    INT 21H

    ; --- 5. Print Month (DH) ---
    MOV BH, 0        ; Clear BH
    MOV BL, DH       ; Move Month (DH) to BL (BH:BL = 00:10h)
    MOV AX, BX       ; AX = Month value (clean 16-bit)
    CALL PrintNumber ; Prints the month (e.g., 10)

    ; --- 6. Print Separator (/) ---
    MOV AH, 09H
    LEA DX, date_separator
    INT 21H

    ; --- 7. Print Year (CX) ---
    MOV AX, CX       ; Year is in CX
    CALL PrintNumber ; Prints the year (e.g., 2025)

    ; --- 8. Exit Program ---
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ----------------------------------------------------------------
; Procedure to print a 16-bit number (AX) to the console (decimal).
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
