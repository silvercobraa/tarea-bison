#!/bin/bash

bison -d xml.y
flex xml.lex
gcc -o reconocedor.out lex.yy.c xml.tab.c -lfl
./reconocedor.out
