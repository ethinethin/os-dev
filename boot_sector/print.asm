print_char:                     ; print the character at address bx
  PUSHA
  MOV ah, 0x0e
  MOV al, [bx]
  INT 0x10
  POPA
  RET

print_string:                   ; print the string at address bx
  PUSHA
string_loop:
  MOV al, [bx]
  CMP al, 0
  JE string_done
  CALL print_char
  ADD bx, 1
  JMP string_loop
string_done:
  POPA
  RET

NEW_LINE: db 0x0A, 0x0D, 0

print_newline:
  PUSH bx
  MOV bx, NEW_LINE
  CALL print_string
  POP bx
  RET

HEX_PREFIX: db "0x", 0
HEX_CHARS: db "0123456789ABCDEF", 0

print_hex:                      ; print the hex value in dx
  PUSHA
  ; output the hex prefix
  MOV bx, HEX_PREFIX
  CALL print_string
  ; set up loop
  MOV ah, 12
print_hex_loop:
  ; copy hex and bit shift right according to the shift index value ([bx])
  MOV cx, dx
  MOV al, ah
print_hex_shift_loop:
  CMP al, 0
  JE print_hex_shift_done
  SHR cx, 1
  SUB al, 1
  JMP print_hex_shift_loop
print_hex_shift_done:
  ; mask all but rightmost half-byte
  AND cx, 0x000F
  ; find appropriate character
  MOV bx, HEX_CHARS
  ADD bx, cx
  CALL print_char
  ; if current shift index is 0, we're done
  CMP ah, 0
  JE print_hex_done
  SUB ah, 4
  MOV al, ah
  JMP print_hex_loop
print_hex_done:
  POPA
  RET

[BITS 32]
; Constants for VGA mode
VIDEO_MEMORY EQU 0xb8000
WHITE_ON_BLACK EQU 0x0f

print_string_pm:      ; print a null-terminated string at ebx
  PUSHA
  MOV edx, VIDEO_MEMORY
print_string_pm_loop:
  MOV al, [ebx]
  MOV ah, WHITE_ON_BLACK
  CMP al, 0
  JE print_string_pm_done
  MOV [edx], ax
  ADD ebx, 1
  ADD edx, 2
  JMP print_string_pm_loop
print_string_pm_done:
  POPA
  RET
