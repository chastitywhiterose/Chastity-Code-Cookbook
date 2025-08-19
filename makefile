source=Chastity-Code-Cookbook.md

title="Chastity's Code Cookbook"
subtitle="Computer Programming Recipes for Technical Math Nerds"
author="Chastity White Rose"

Make-Ebook:
	pandoc $(source) -o ebook.epub -s --metadata title=$(title) --metadata subtitle=$(subtitle) --metadata author=$(author)
docx:
	pandoc $(source) -o book.docx --reference-doc custom-reference.docx
odt:
	pandoc $(source) -o book.odt --reference-doc custom-reference.odt
html:
	pandoc $(source) -o book.html
html-book:
	pandoc $(source) -o book.html -s --metadata title=$(title) --metadata subtitle=$(subtitle) --metadata author=$(author)
push:
	git add .
	git commit # -m "Code Cookbook Update"
	git push
