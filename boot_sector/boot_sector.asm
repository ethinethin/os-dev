[ORG 0x7c00]

  MOV [BOOT_DRIVE], dl          ; Copy boot drive (in dl) from BIOS to memory
  MOV bp, 0x8000
  MOV sp, bp

  MOV bx, 0x9000                ; load 5 sectors to [0x0000 (ES) + 0x9000]
  MOV dh, 2
  MOV dl, [BOOT_DRIVE]
  CALL disk_load

  MOV dx, [0x9000]              ; print out the first loaded word
  CALL print_hex
  CALL print_newline

  MOV dx, [0x9000 + 512]        ; print out first word in the second sector
  CALL print_hex
  CALL print_newline
  
  jmp $

%include "print.asm"
%include "disk_load.asm"

; Global variables
BOOT_DRIVE: db 0

; Boot sector padding
TIMES 510-($-$$) DB 0
DW 0xaa55

; Disk space
TIMES 256 DW 0x4141
TIMES 256 DW 0x7373
