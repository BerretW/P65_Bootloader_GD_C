del .\output\*.*

cd .\src
cc65 -t none -O --cpu 65C02 main.c
cc65 -t none -O --cpu 65c02 gameduino.c
ca65 --cpu 65c02 main.s -o ..\output\main.o -l ..\output\main.lst
ca65 --cpu 65c02 gameduino.s -o ..\output\gameduino.o -l ..\output\gameduino.lst
ca65 --cpu 65c02 gd.asm -o ..\output\gd.o
ca65 --cpu 65c02 spi.asm -o ..\output\spi.o
ca65 --cpu 65c02 vectors.asm -o ..\output\vectors.o
ca65 --cpu 65c02 acia.asm -o ..\output\acia.o
ca65 --cpu 65c02 interrupts.asm -o ..\output\interrupts.o
ca65 --cpu 65c02 jumptable.asm -o ..\output\jumptable.o
ca65 --cpu 65c02 pckybd.asm -o ..\output\pckybd.o
ca65 --cpu 65c02 utils.asm -o ..\output\utils.o -l ..\output\utils.lst
ca65 --cpu 65c02 sn76489.asm -o ..\output\sn76489.o
ca65 --cpu 65c02 zeropage.asm -o ..\output\zeropage.o
ca65 --cpu 65c02 ewoz.asm -o ..\output\ewoz.o

move *.s ..\output

cd ..\output

ld65 -C APP_RAM_DISK.cfg -m ram.map main.o spi.o acia.o gameduino.o gd.o interrupts.o vectors.o jumptable.o pckybd.o utils.o sn76489.o zeropage.o ewoz.o ..\library\p65.lib -o ..\output\RAM.bin

cl65.exe -m rom.map main.o spi.o acia.o gameduino.o gd.o interrupts.o vectors.o jumptable.o pckybd.o utils.o sn76489.o zeropage.o ewoz.o -C ..\config\appartus.cfg ..\library\p65.lib -o ..\output\ROM.bin
