.MODEL SMALL
.STACK 100H

.DATA
msg_start   DB 'Total available memory: $'
msg_kb      DB ' KB', 0DH, 0AH, '$'

mem_size_dw DW ? ; Variable to store the 16-bit memory size in paragraphs (16 bytes)

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- 1. Get Available Memory (Using INT 21h, AH=48h) ---
    ; To find the MAXIMUM available memory, we try to allocate an impossibly large block (FFFFh paragraphs).
    MOV AH, 48H      ; Function 48h: Allocate Memory Block
    MOV BX, 0FFFFH   ; Request FFFFh paragraphs (the largest possible request)
    INT 21H          ; Execute DOS interrupt

    ; The allocation fails because there isn't FFFFh paragraphs of memory available.
    ; On failure, the Carry Flag (CF) is set, and BX contains the size of the largest
    ; UNUSED memory block, in PARAGRAPHS (1 paragraph = 16 bytes).

    ; --- 2. Convert and Store Result ---
    JNC EXIT_ERROR   ; If CF is NOT set, something went wrong, just exit.

    ; BX now holds the size in paragraphs (e.g., 640/16 = 40h paragraphs)
    MOV mem_size_dw, BX ; Store size in paragraphs

    ; --- 3. Display Message ---
    MOV AH, 09H
    LEA DX, msg_start
    INT 21H

    ; --- 4. Convert and Print Memory Size ---
    ; To get KB, we need to convert BX (paragraphs) to decimal.
    ; This code calls PrintNumber to handle the multi-digit conversion.
    MOV AX, mem_size_dw ; Load the paragraph count into AX
    CALL PrintNumber    ; Print the paragraph count

    ; --- 5. Print " KB" ---
    MOV AH, 09H
    LEA DX, msg_kb
    INT 21H

    JMP EXIT_PROGRAM

EXIT_ERROR:
    ; Simple error handler (only for unexpected success of AH=48h)
    MOV AH, 09H
    LEA DX, msg_kb ; Reuse the KB string for newline/cleanup
    INT 21H

EXIT_PROGRAM:
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ----------------------------------------------------------------
; Procedure to print a 16-bit number (AX) to the console (decimal).
; (Same reliable procedure used in previous problems)
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
