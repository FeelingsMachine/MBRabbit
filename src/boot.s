.code16
.globl _start

.section .text
# =============================================================================
# MBRabbit
# =============================================================================

_start:
  # Initialize segment registers
  xorw    %ax,        %ax
  movw    %ax,        %ds
  movw    %ax,        %es

  # Display welcome message
  movw    $lword,     %si
  call    strprint

# =============================================================================
# Main Input Loop
# =============================================================================
input_loop:
  call    get_key
  call    chr_event_handler
  jmp     input_loop

# =============================================================================
# Character Event Handler
# Processes keyboard input and handles special characters
# Input: AL - ASCII character
# Output: AH - Status (0 success, -1 error)
# =============================================================================
chr_event_handler:
  # Check for special characters
  cmpb    $0x0D,      %al     # Check for Enter key
  je      .spchr_newline
  cmpb    $0x08,      %al     # Check for Backspace
  je      .spchr_backspace

  call    chrprint
  jmp     .stat_error         # No special character matched

# =============================================================================
# Special Character Handlers
# =============================================================================
.spchr_newline:
  movb    $0x0A,      %al     # Line feed
  call    chrprint
  movb    $0x0D,      %al     # Carriage return
  call    chrprint
  call    chrprint
  jmp     .stat_sucess

.spchr_backspace:
  movw    $.spchr_table, %si
  call    strprint
  jmp     .stat_sucess

# =============================================================================
# Utility Functions
# =============================================================================

# Get keyboard input
# Output: AL - ASCII character
get_key:
  movb    $0x00,      %ah     # BIOS keyboard service
  int     $0x16
  ret

# Print single character
# Input: AL - Character to print
chrprint:
  movb    $0x0E,      %ah     # BIOS teletype output
  movw    $0x0007,    %bx     # Page 0, light gray on black
  int     $0x10
  ret

# Store character in buffer
# Input: AL - Character to store
chrstore:
  # TODO:

# Print null-terminated string
# Input: SI - Pointer to string
strprint:
  lodsb                       # Load byte from [DS:SI] into AL
  test    %al,        %al     # Check for null terminator
  jz      generic_sucess      # If zero, return
  movb    $0x0E,      %ah     # BIOS teletype output
  int     $0x10
  jmp     strprint            # Continue loop

# Compare strings (Work in Progress)
# Input: SI - First string
#        BL - Second string
strcmp:
  lodsb
  testb   %al,        %al     # Check for end of first string
  jz      .stat_error 
  test    %bl,        %bl     # Check for end of second string
  jz      .stat_error 

  cmpb    %al,        %bl     # Compare characters
  je      generic_sucess
  jmp     strcmp

# =============================================================================
# Status Return Functions
# =============================================================================
generic_sucess:
  ret

.stat_sucess:
  movb    $0,         %ah
  ret

.stat_error:
  movb    $-1,        %ah
  ret

# =============================================================================
# Data Section
# =============================================================================
.spchr_table:                   # Special character sequences
  .byte 0x08, 0x20, 0x08, 0x00  # Backspace sequence: BS, Space, BS, NULL

lword: .asciz "Hello, World!\r\n"
buffer: .space 8                # Input buffer (8 characters)

# Boot sector signature
.fill 510-(.-_start), 1, 0      # Pad to 510 bytes
.word 0xaa55                    # Boot signature

