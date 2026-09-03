.model small
.stack 100h
.data
prompt_in   DB "Enter string to modify (max 80 chars): $"
prompt_out  DB 0Dh, 0Ah, "Modified string: $"
buffer      DB 80, ?, 80 DUP('$')
target_char EQU 'A'
replace_char EQU 'X'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; --- 1. Get String Input ---
    mov ah, 09h
    lea dx, prompt_in
    int 21h
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; --- 2. Setup Loop ---
    mov cl, BYTE PTR [buffer + 1] ; CL = Actual length (Loop counter)
    mov ch, 0                     ; CX = Actual length
    mov si, OFFSET buffer + 2     ; SI points to the first character

replace_loop:
    cmp BYTE PTR [si], target_char  ; Is the current char 'A'?
    jne next_char                   ; If not, skip replacement

    mov BYTE PTR [si], replace_char ; If it is 'A', replace it with 'X'

next_char:
    inc si                          ; Move to the next character
    loop replace_loop               ; Decrement CX and jump back if CX > 0

    ; --- 3. Display Result Message ---
    mov ah, 09h
    lea dx, prompt_out
    int 21h

    ; --- 4. Print Modified String ---
    mov ah, 09h
    lea dx, buffer + 2              ; Print the string, starting after headers
    int 21h

    ; --- 5. Exit ---
    mov ah, 4Ch
    int 21h
main endp
end main