        bits 64

        section .rodata
msg:    db  "Hello world", 0x0A
msglen: equ $ - msg

        section .text
        global _start

_start:
        ; sys_write(1, msg, msglen)
        mov     rax, 1        ; system call: write
        mov     rdi, 1        ; fd = stdout
        mov     rsi, msg      ; address of buffer
        mov     rdx, msglen   ; length of buffer
        syscall

        ; sys_exit(0)
        mov     rax, 60       ; system call: exit
        xor     rdi, rdi      ; status = 0
        syscall
