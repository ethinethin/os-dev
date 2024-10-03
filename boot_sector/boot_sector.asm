[ORG 0x7c00]
KERNEL_OFFSET EQU 0x1000

	; Save boot drive number from BIOS
	MOV [BOOT_DRIVE], dl

	; Set up stack at 0x9000
	MOV bp, 0x9000
	MOV sp, bp

	; Output that real mode is being entered
	MOV bx, MSG_REAL_MODE
	CALL print_string
	CALL print_newline

	; Load kernel
	CALL load_kernel

	; Switch to protected mode
	CALL switch_to_pm
	JMP $				; this instruction is never reached

%include "disk_load.asm"
%include "print.asm"
%include "gdt.asm"
%include "switch_to_pm.asm"

[BITS 16]
; routine to load kernel
load_kernel:
	; Output that kernel is being loaded
	MOV bx, MSG_LOAD_KERNEL
	CALL print_string
	CALL print_newline
	; Load 1 sector (after boot sector) to the kernel offset
	MOV bx, KERNEL_OFFSET
	MOV dh, 1
	MOV dl, [BOOT_DRIVE]
	CALL disk_load
	RET

[BITS 32]
BEGIN_PM:				; entry point for 32-bit protected mode
	; Output that protected mode is entered
	MOV ebx, MSG_PROT_MODE
	CALL print_string_pm
	; Load the kernel
	CALL KERNEL_OFFSET
	JMP $				; this instruction is never reached


; Global variables
BOOT_DRIVE: DB 0
MSG_REAL_MODE: DB "Started in 16-bit real mode", 0
MSG_PROT_MODE: DB "Successfully entered 32-bit protected mode", 0
MSG_LOAD_KERNEL: DB "Loading kernel into memory", 0

; Boot sector padding
TIMES 510-($-$$) DB 0
DW 0xaa55
