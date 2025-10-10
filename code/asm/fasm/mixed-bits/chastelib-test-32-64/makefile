chastelib-test-both:
	fasm chastelib-test-32.asm
	chmod +x chastelib-test-32
	./chastelib-test-32
	fasm chastelib-test-64.asm
	chmod +x chastelib-test-64
	./chastelib-test-64
meld:
	meld chastelib-test-32.asm chastelib-test-64.asm
diffuse:
	diffuse chastelib-test-32.asm chastelib-test-64.asm
