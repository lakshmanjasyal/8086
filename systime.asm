.MODEL SMALL
.STACK 100H
.DATA
    MSG  DB 'Current System Time is: $'
    HOUR DB ?
    MIN  DB ?
    SEC  DB ?
    DISP DB '00:00:00$'   
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Display message
    LEA DX, MSG
    MOV AH, 09H
    INT 21H

    ; Get system time
    MOV AH, 2CH    
    INT 21H         

    ; Save values
    MOV HOUR, CH
    MOV MIN, CL
    MOV SEC, DH

    ; Convert and store in DISP
    LEA SI, DISP

    ; Hour (two chars)
    MOV AL, HOUR
    CALL CONVERT
    MOV BYTE PTR [SI], AH     
    MOV BYTE PTR [SI+1], AL     

    ; Colon
    MOV BYTE PTR [SI+2], ':'

    ; Minute
    MOV AL, MIN
    CALL CONVERT
    MOV BYTE PTR [SI+3], AH
    MOV BYTE PTR [SI+4], AL

    ; Colon
    MOV BYTE PTR [SI+5], ':'

    ; Second
    MOV AL, SEC
    CALL CONVERT
    MOV BYTE PTR [SI+6], AH
    MOV BYTE PTR [SI+7], AL

    ; Display final time
    LEA DX, DISP
    MOV AH, 09H
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP


CONVERT PROC
    ; Convert a value (stored in AL) into two ASCII characters for tens and units
    MOV AH, 0
    MOV BL, 10
    DIV BL          ; AX / 10 -> AL = quotient (tens), AH = remainder (units)

    ADD AL, 30H     ; tens -> ASCII
    ADD AH, 30H     ; units -> ASCII

    XCHG AH, AL     ; swap so AH = tens ASCII, AL = units ASCII
    RET
CONVERT ENDP

END MAIN