# chastelib core library for FreeBASIC

## Terminology

FreeBASIC is the best modern compiler that supports a BASIC dialect similar to QBASIC, which was my first programming language.

chastelib is the collection of functions I use in my own projects, specifically involving converting between integers and strings is multiple bases.

## Design of chastelib

Unlike the C Programming Language, BASIC has a number of dialects which support different data types and built in functions. It would be silly to try to conform to all dialects.

However, FreeBASIC has different language switches which can determine whether it uses the modern FreeBASIC extended types and features or whether it tries to keep compatibility with QBASIC and QuickBASIC for DOS. I have decided that a well designed library should compile with a "-lang" option of either "fb" or "qb".
