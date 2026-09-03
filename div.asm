.MODEL SMALL
.STACK 100H

.DATA
msg1 DB 'Enter dividend (0-9): $'
msg2 DB 0DH,0AH,'Enter divisor (0-9): $'
msgQuot DB 0DH,0AH,'Quotient is: $'
msgRem  DB 0DH,0AH,'Remainder is: $'
errMsg DB 0DH,0AH,'Error: Division by zero!$'

num1 DB ?
num2 DB ?
quot DB ?
rem  DB ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, msg1
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    MOV num1, AL

    LEA DX, msg2
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    MOV num2, AL

    MOV AL, num2
    CMP AL, 0
    JE DIV_ZERO

    MOV AL, num1
    MOV BL, num2
    MOV AH, 0
    DIV BL
    MOV quot, AL
    MOV rem, AH

    LEA DX, msgQuot
    MOV AH, 09H
    INT 21H

    MOV AL, quot
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    LEA DX, msgRem
    MOV AH, 09H
    INT 21H

    MOV AL, rem
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    JMP EXIT_PROGRAM

DIV_ZERO:
    LEA DX, errMsg
    MOV AH, 09H
    INT 21H

EXIT_PROGRAM:
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN