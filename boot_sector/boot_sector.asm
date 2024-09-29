[ORG 0x7c00]

	MOV bp, 0x9000
	MOV sp, bp

	MOV bx, MSG_REAL_MODE
	CALL print_string

	CALL switch_to_pm
	JMP $				; this instruction is never reached

%include "print.asm"
%include "gdt.asm"
%include "switch_to_pm.asm"

[BITS 32]
BEGIN_PM:				; entry point for 32-bit protected mode
	MOV ebx, MSG_PROT_MODE
	CALL print_string_pm
	JMP $				; Nothing to do yet so just loop


; Global variables
MSG_REAL_MODE: DB "Started in 16-bit real mode", 0
MSG_PROT_MODE: DB "Successfully entered 32-bit protected mode", 0

; Boot sector padding
TIMES 510-($-$$) DB 0
DW 0xaa55
