Make-Ebook:
	pandoc Chastity-Code-Cookbook.md -o ebook.epub -s --metadata title="Chastity's Code Cookbook" --metadata subtitle="Computer Programming Recipes for Technical Math Nerds" --metadata author="Chastity White Rose"
docx:
	pandoc Chastity-Code-Cookbook.md -o book.docx --reference-doc custom-reference.docx
odt:
	pandoc Chastity-Code-Cookbook.md -o book.odt --reference-doc custom-reference.odt
html:
	pandoc Chastity-Code-Cookbook.md -o book.html
html-book:
	pandoc Chastity-Code-Cookbook.md -o book.html -s --metadata title="Chastity's Code Cookbook" --metadata subtitle="Computer Programming Recipes for Technical Math Nerds" --metadata author="Chastity White Rose"
push:
	git add .
	git commit -m "Code Cookbook Update"
	git push
