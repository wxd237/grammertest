#!/bin/sh

bison -dv c.y
flex c.l
cc c.tab.c lex.yy.c
