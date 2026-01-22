main-6502-vasm_oldstyle:
	vasm6502_oldstyle  main.asm -cbm-prg -Fbin -o main.prg
extra:
	vasm6502_oldstyle  main.asm -cbm-prg -Fbin -o main.prg -L Listing.txt -chklabels
run:
	x64sc -autostart main.prg
