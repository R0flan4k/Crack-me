.model tiny
.386
.code
org 100h

PasswordLen equ 3   ; Length of right password.

Start:
    push cs
    pop es
    mov di, offset PasswordField

GetInput:
    mov ah, 0
    int 16h             ; Reading keyboard input.
    cmp ah, 1ch
    je ComparePassword  ; Stop getting input if Enter was pressed.

    stosb               ; Moving symbol to PasswordField.
    jmp GetInput

ComparePassword:
    push cs
    pop ds
    mov di, offset PasswordField
    mov si, offset RightPassword

    mov cx, PasswordLen

CompareCycle:           ; Cycle comparing inputed password (PasswordField)
    cmpsb               ; and right password (RightPassword).
    jne Failure

    dec cx
    cmp cx, 0
    je Success

    jmp CompareCycle

Failure:
    mov dx, offset FailureMsg
    jmp PrintString

Success:
    mov dx, offset SuccessMsg
    mov ax, 0900h       ; Display text from dx.
    int 21h

    call SevenNationArmy
    jmp Exit

PrintString:
    mov ax, 0900h       ; Display text from dx.
    int 21h

Exit:
    mov ax, 4c00h       ; Terminate program with 0 exit code.
    int 21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description:  Playin White Stripes - "Seven Nation Army".
; Assumes:      nothing.
; Destroys:     ax, bx, di.
; Returns:      Cool music :)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SevenNationArmy proc
    mov di, 20001
    mov bx, 200
    call sound

    mov di,659   ;частота звука
    mov bx,150   ;длительность
    call sound
    mov di, 20001
    mov bx, 50
    call sound
    mov di, 659
    mov bx, 100
    call sound
    mov di,784
    call sound
    mov di,659
    call sound
    mov di,587
    call sound
    mov di,523
    call sound
    mov di, 20001
    mov bx, 200
    call sound
    mov bx, 100
    mov di,493
    call sound

    mov di, 20001
    mov bx, 200
    call sound

    mov di,659
    mov bx,150
    call sound
    mov di, 20001
    mov bx, 50
    call sound
    mov di, 659
    mov bx, 100
    call sound
    mov di,784
    call sound
    mov di,659
    call sound
    mov di,587
    call sound
    mov di,523
    call sound

    mov di, 587
    call sound
    mov di, 523
    call sound

    mov di,493
    call sound

    ret
    endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description:  Plays a note with frequency di
;               for bx units of time.
; Assumes:      di = *frequency*,
;               bx = *duration*.
; Destroys:     nothing.
; Returns:      nothing.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sound proc
    pusha
    ;mov di,6000   ;частота звука
    ;mov bx,2000   ;длительность
    mov al,0b6H
    out 43H,al
    mov dx,0014H
    mov ax,4f38H
    div di
    out 42H,al
    mov al,ah
    out 42H,al
    in al,61H
    mov ah,al
    or al,3
    out 61H,al
    l1:     mov cx,2801H
    l2:     loop l2
    dec bx
    jnz l1
    mov al,ah
    out 61H,al
    popa
    ret
sound endp

.data
    SuccessMsg      db 'Success. Access unlocked.', 0dh, 0ah, '$'
    FailureMsg      db 'Failure. Access denied.', 0dh, 0ah, '$'
    PasswordField   db 3 dup(0)
    RightPassword   db 'HUY'
End Start
