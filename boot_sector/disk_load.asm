disk_load:				; load dh sectors to es:bx from drive dl
	PUSH dx

	; Set up initial parameters
	MOV ah, 0x02			; BIOS read sector function
	MOV al, dh			; Read "dh" sectors, from:
	MOV ch, 0x00			; Cylinder 0
	MOV dh, 0x00			; Head 0
	MOV cl, 0x02			; Start reading from the second sector (after the boot sector)
	INT 0x13			; BIOS interrupt for reading

	; Check for errors
	JC disk_error			; carry flag set, error

	; Compare number of sectors read to number desired
	POP dx
	CMP dh, al
	JNE disk_error
	RET

disk_error:
	MOV bx, DISK_ERROR_MSG
	CALL print_string
	JMP $

DISK_ERROR_MSG: DB "Disk read error", 0
