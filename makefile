source=Chastity-Code-Cookbook.md

title="Chastity's Code Cookbook"
subtitle="Computer Programming Recipes for Technical Math Nerds"
author="Chastity White Rose"

Make-Ebook:
	pandoc $(source) -o ebook.epub -s --metadata title=$(title) --metadata subtitle=$(subtitle) --metadata author=$(author)
docx:
	pandoc Chastity-Code-Cookbook.md -o book.docx --reference-doc custom-reference.docx
odt:
	pandoc Chastity-Code-Cookbook.md -o book.odt --reference-doc custom-reference.odt
html:
	pandoc Chastity-Code-Cookbook.md -o book.html
html-book:
	pandoc Chastity-Code-Cookbook.md -o book.html -s --metadata title=$(title) --metadata subtitle=$(subtitle) --metadata author=$(author)
push:
	git add .
	git commit # -m "Code Cookbook Update"
	git push
