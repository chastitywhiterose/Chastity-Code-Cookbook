chastelib-test-main:
	fasm hello32.asm
	chmod +x hello32
	./hello32
	fasm hello64.asm
	chmod +x hello64
	./hello64
meld:
	meld hello32.asm hello64.asm
diffuse:
	diffuse hello32.asm hello64.asm
geany:
	geany hello32.asm hello64.asm
codediff:
	code --diff hello32.asm hello64.asm
	
