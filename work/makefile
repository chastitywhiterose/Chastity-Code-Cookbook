main1=chastext-dos.asm
main2=chastext-win.asm
lib1=chastelib16.asm
lib2=chastelibw32.asm

chastelib-test-main:
	diff $(main1) $(main2)
meld:
	meld $(main1) $(main2)
diffuse:
	diffuse $(main1) $(main2)
geany:
	geany $(main1) $(main2)
codediff:
	code --diff $(main1) $(main2)
winmerge:
	winmergeu $(main1) $(main2)
