section .text
global _start

_start:
    ; We push the bytes of "Hello World!\n" in reverse order so that
    ; in memory (from lower to higher addresses) they appear as:
    ;    H e l l o   W o r l d ! \n

    ; 1) '\n' (0x0a)
    push byte  0x0a
    
    ; 2) "rld!" -> ASCII bytes = 72 6c 64 21 (0x21646c72)
    push dword 0x21646c72

    ; 3) "o Wo" -> 6f 20 57 6f (0x6f57206f)
    push dword 0x6f57206f

    ; 4) "Hell" -> 48 65 6c 6c (0x6c6c6548)
    push dword 0x6c6c6548

    ; ecx => start of string on the stack
    mov ecx, esp

    ; 13 bytes total: "Hello World!\n"
    mov edx, 13

    ; File descriptor = 1 (stdout)
    mov ebx, 1

    ; eax = 4 => sys_write
    mov eax, 4
    int 0x80

    ; exit(0)
    mov eax, 1
    xor ebx, ebx
    int 0x80
