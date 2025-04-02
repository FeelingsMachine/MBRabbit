# MBRabbit
```
(\ /)
( . .)
c(")(")
```
This is a very simple MBR bootloader, which I plan to slowly increment;

## Features:
  * IO implemented
  * Some special character handling (newlines and backspace)

### Building dependencies:
  * lolcal (It is a very important part of the project)
  * as (You probably already have it)
  * ld (Also probably already have it)
  * make
  * qemu-system-x86_64 (The emulator, you can probably use others)

## Building:
```
git clone https://github.com/FeelingsMachine/MBRabbit/
cd MBRabbit
make
```
To run use `make run` (Uses qemu-system-x86_64)
