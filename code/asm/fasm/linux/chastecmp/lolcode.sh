speed=16
lolcat main.asm -a -s $speed
lolcat chasteio32.asm -a -s $speed
chastehex chastecmp | lolcat -a -s $speed
