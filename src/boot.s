.code16
.globl _start

.section .text
_start:
  # Cleanup segments
  xorw  %ax,      %ax
  movw  %ax,      %ds
  movw  %ax,      %es

  # Print welcome message
  movw  $lword,   %si
  call  strprint

input_loop:
  call  get_key
  call  chr_event_handler
  jmp   input_loop

chr_event_handler:
  # The event handler is responsible for parsing the input and handling the events
  # It is a WIP, eventually I will optimize and add more events

  # NOTE: I can definitely make this more efficient by using strcmp
  #         Just like, chain every character in a single null terminated string
  cmpb  $0x0D,    %al
  je    .spchr_newline
  cmpb  $0x08,    %al
  je    .spchr_backspace

  call  chrprint
  jmp   .stat_error     # No matches found

# TODO: The special character events could be much better optimized
.spchr_newline:
  movb  $0x0A,    %al
  call chrprint
  movb  $0x0D,    %al
  call chrprint
  call  chrprint

  jmp   .stat_sucess

.spchr_backspace:
  movw  $.spchr_table, %si
  call  strprint

  jmp .stat_sucess

.spchr_table: # Subject to changes 
  # Backspace procedure
  .byte 0x08, 0x20, 0x08, 0x00  # BS, WS, BS, NULL

get_key:
  movb  $0x00,    %ah
  int   $0x16
  ret

chrprint:
  movb  $0x0E,    %ah   # Teletype output
  movw  $0x0007,  %bx   # Page number, foreground colour
  int   $0x10
  ret

strprint:
  lodsb                 # Load byte from [DS:SI] into AL
  test  %al,      %al   # Check for null terminator
  jz    generic_sucess  # If zero, return
  movb  $0x0E,    %ah   # Otherwise print character
  int   $0x10
  jmp   strprint        # Continue loop

strcmp:  # Untested
  lodsb
  testb   %al,    %al   # Null check
  jz      .stat_error 
  test    %bl,    %bl
  jz      .stat_error 

  cmpb    %al,    %bl   # al == bl
  je      generic_sucess
  jmp strcmp

generic_sucess:
  ret

.stat_sucess:
  movb    $0,     %ah
  ret

.stat_error:
  movb    $-1,    %ah
  ret

lword: .asciz "Hello, World!\r\n"

.fill 510-(.-_start), 1, 0
.word 0xaa55

