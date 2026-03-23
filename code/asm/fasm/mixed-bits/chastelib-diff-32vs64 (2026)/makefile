chastelib-test-main:
	fasm main32.asm
	chmod +x main32
	./main32
	fasm main64.asm
	chmod +x main64
	./main64
meld:
	meld main32.asm main64.asm
meld-lib:
	meld chastelib32.asm chastelib64.asm
diffuse:
	diffuse main32.asm main64.asm
diffuse-lib:
	diffuse chastelib32.asm chastelib64.asm
geany:
	geany main32.asm main64.asm
	
