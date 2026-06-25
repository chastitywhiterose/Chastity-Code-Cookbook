#!/bin/sh
cat seashell.txt
cp seashell.txt 0.txt
echo
sed 's/She/Chastity/g' -i 0.txt
sed 's/sells/writes/g' -i 0.txt
sed 's/seashells/assembly books/g' -i 0.txt
sed 's/seashore/computer/g' -i 0.txt
sed 's/shells/books/g' -i 0.txt
sed 's/by the/on her/g' -i 0.txt
cat 0.txt

