# HelloWorldLight
An attempt at making the lightest possible binary of a Hello World program, using a **minimal** x86 32-bit Linux “Hello World” program in NASM Assembly. It demonstrates how to push the string onto the stack in the correct byte order for a proper printout.

---

## Description

This NASM Assembly program:
1. Pushes `"Hello World!"` onto the stack in reverse order (accounting for little-endian).
2. Calls the Linux **sys_write** system call to print to stdout.
3. Exits gracefully with **sys_exit**.

It’s meant to be **as small as possible** while still being a fully valid, standalone ELF binary for 32-bit Linux.

---

## Code

```asm
section .text
global _start

_start:
    ; Push the string "Hello World!\n" in reverse order
    push byte  0x0a         ; '\n'
    push dword 0x21646c72   ; "rld!"
    push dword 0x6f57206f   ; "o Wo"
    push dword 0x6c6c6548   ; "Hell"

    mov ecx, esp            ; ecx points to the start of the string
    mov edx, 13             ; length of "Hello World!\n"
    mov ebx, 1              ; file descriptor (stdout)
    mov eax, 4              ; sys_write
    int 0x80

    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; return code 0
    int 0x80
```

## How to Build and Run
Note: You’ll need the NASM assembler and a linker that can produce 32-bit ELF binaries.

1. Assemble:

```bash nasm -f elf32 hello.asm -o hello.o```

This creates a 32-bit object file named hello.o.

2. Link:

```bash ld -m elf_i386 -s hello.o -o hello```

-m elf_i386 forces 32-bit mode.
-s strips debugging symbols to reduce file size.
This produces the executable named hello.

3. Execute:

```bash ./hello```

You should see:
Hello World!

## Troubleshooting
- command not found: nasm
Install NASM via your package manager. 
  - For example (Debian/Ubuntu):

    ```bash
    apt-get update
    apt-get install nasm
    ```

- Linker issues or ld not found
Make sure you have binutils (which includes ld). 
  - For Debian/Ubuntu:

  ```bash
  apt-get install binutils
  ```

- Incorrect output
Ensure the push instructions are in the correct order.
Double-check you are assembling as 32-bit code, not 64-bit.
Verify you used -f elf32 with NASM and -m elf_i386 with ld.


