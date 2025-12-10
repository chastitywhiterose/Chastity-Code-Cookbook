#!/bin/bash

echo "Converting all Markdown files in public directory to html with pandoc"

for file in public/*.md;
do

command="pandoc ${file} -o ${file%.*}.html -s --quiet"
echo $command
$command

done
