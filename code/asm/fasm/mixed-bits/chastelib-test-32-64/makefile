chastelib-test-both:
	fasm chastelib32-test.asm
	chmod +x chastelib32-test
	./chastelib32-test
	fasm chastelib64-test.asm
	chmod +x chastelib64-test
	./chastelib64-test
meld:
	meld chastelib32-test.asm chastelib64-test.asm
diffuse:
	diffuse chastelib32-test.asm chastelib64-test.asm
