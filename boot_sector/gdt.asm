; The initial GDT - I am just setting up two overlapping segments, one for code
;   and one for data. This will get us into 32-bit protected mode, where we can
;   change the GDT to a more preferable state.

gdt_start:

gdt_null:				; the null segment descriptor
	DD 0x0
	DD 0x0

gdt_code:				; the code segment descriptor
	DW 0xffff			; limit bits 0-15
	DW 0x0				; base bits 0-15
	DB 0x0				; base bits 16-23
	DB 10011010b			; Flags: P=1, DPL=00, S=1, Type = 1 (code), 0 (not conforming), 1 (readable), 0 (accessed)
	DB 11001111b			; G=1, D=1, L=0, AVL=0, limit bits 16-19
	DB 0x0				; base bits 24-31

gdt_data:				; the data segment descriptor
	DW 0xffff			; limit bits 0-15
	DW 0x0				; base bits 0-15
	DB 0x0				; base bits 16-23
	DB 10010010b			; Flags: P=1, DPL=00, S=1, Type = 0 (data), 0 (not conforming), 1 (readable), 0 (accessed)
	DB 11001111b			; G=1, D=1, L=0, AVL=0, limit bits 16-19
	DB 0x0				; base bits 24-31

gdt_end: 				; for calculating values below

gdt_descriptor:				; the GDT descriptor itself (what we give to the CPU)
	DW gdt_end - gdt_start - 1	; size of the GDT minus 1
	DD gdt_start			; start address

; constants for segment descriptor offsets
CODE_SEG EQU gdt_code - gdt_start
DATA_SEG EQU gdt_data - gdt_start



