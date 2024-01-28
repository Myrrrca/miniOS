org 0x7C00
mov [DISK_NUM], dl


mov ah, 2       ;for int 13h
mov dl, [DISK_NUM]
mov dh, 0
mov ch, 0
mov cl, 2
mov al, 1

mov di, alValue         ;cos int 13h changing al value
mov [di], al
push ax
mov ax, 0
mov es, ax
pop ax
mov bx, 0x7e00
int 0x13

mov ah, 0x0e

push ax
lahf
shl ah, 7
cmp ah, 128
jz cfError
pop ax
cfOut:

mov di, alValue
mov al, [di]
cmp al, 1
jnz alError
;alOut:


mov ah, 0x0e
mov di, bx
mov al, [di]     ;char for output
int 0x10
jmp endd

cfError:
pop ax
mov ah, 0x0e
mov di, cfErrorMsg
loop1:
        cmp al, '0'
        jz loop1_out
        mov al, [di]
        int 0x10
        inc di
        jmp loop1
loop1_out:
jmp cfOut

alError:
mov ah, 0x0e
mov di, alErrorMsg
loop2:
        cmp al, '0'
        jz loop2_out
        mov al, [di]
        int 0x10
        inc di
        jmp loop2
loop2_out:
;jmp alOut

endd:

jmp $
DISK_NUM: db 0
cfErrorMsg: db "carry flag equals 1, error!0"
alErrorMsg: db "al register is not equal 1, error!0"
alValue: db 0

times 510 - ($ - $$) db 0
db 0x55, 0xAA



;new sector
times 512 db 'A'

