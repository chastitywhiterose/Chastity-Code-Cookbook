#!/bin/bash

mkdir -p public

cat > public/index.md << EOF
# Home Page
Welcome to the home page of my website! There is not much here but you can learn more [about me](about.html).
EOF

cat > public/about.md << EOF
# About Me
One thing you should know about me is that I prefer computers over people because they operate correctly most of the time, and even when they don't, I can buy a replacement. This is why I have two computers and no friends.

Go back to [home page](index.html).
EOF

