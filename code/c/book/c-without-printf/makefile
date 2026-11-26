source=c-without-printf.md

title="C Without Printf"
subtitle="Build a Low-Level I/O Library From Ground Zero"
author="Chastity White Rose"

ebook:
	pandoc $(source) -o ebook.epub -s --metadata title=$(title) --metadata subtitle=$(subtitle) --metadata author=$(author)
odt:
	pandoc $(source) -o book.odt --reference-doc custom-reference-7x10.odt
docx:
	pandoc $(source) -o book.docx --reference-doc custom-reference.docx
html:
	pandoc $(source) -o book.html
html-book:
	pandoc $(source) -o book.html -s --metadata title=$(title) --metadata subtitle=$(subtitle) --metadata author=$(author)
