[BITS 16]
switch_to_pm:				; switch to 32-bit protected mode
	; clear interrupts
	CLI
	; load GDT descriptor
	LGDT [gdt_descriptor]
	; Switch to protected mode
	MOV eax, cr0
	OR eax, 0x1
	MOV cr0, eax
	; Perform a far jump to a 32-bit region; also flushes pipeline
	JMP CODE_SEG:init_pm


[BITS 32]
init_pm:				; initialize registers and stack
	MOV ax, DATA_SEG
	MOV ds, ax
	MOV ss, ax
	MOV es, ax
	MOV fs, ax
	MOV gs, ax
	MOV ebp, 0x90000
	MOV esp, ebp
	CALL BEGIN_PM			; move to the 32-bit region
