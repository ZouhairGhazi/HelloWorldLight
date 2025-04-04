# HelloWorldLight
An attempt at making the lightest possible binary of a Hello World program, using a **minimal** x86 64-bit Linux “Hello World” program in NASM Assembly. 

It demonstrates how to push the string onto the stack in the correct byte order for a proper printout.

The size of the executable is 464 bytes.

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
```

## How to Build and Run
Note: You’ll need the NASM assembler and a linker that can produce 64-bit ELF binaries.

1. Assemble:

```nasm -f elf64 hello.asm -o hello.o```

This creates a 64-bit object file named hello.o.

2. Link:

```ld -m elf_x86_64 -s -n -nostdlib -o hello hello.o```

This command uses the GNU linker to combine object files and create executables. -m elf_x86_64 is used to specifiy the target format.
-s: reduces the binary size by removing unnecessary metadata (e.g. function names, source mappings, etc).
-n: is very important. It disables page alignment of sections. Normally, the linker aligns sections to page boundaries (like 4096 bytes). This flag tells the linker not to do that, reducing binary size significantly.
-nostdlib: Tells the linker not to use the standard libraries. Skips linking against libc, crt0.o, and other default startup files. This is essential when doing direct syscalls (as in our assembly), and when we don’t need anything from libc. This also prevents large dependencies from bloating the binary.

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


