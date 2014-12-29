
all:test

test:c.tab.o lex.yy.o
	cc lex.yy.o c.tab.o


lex.yy.o:lex.yy.c


lex.yy.c:c.l
	flex c.l

c.tab.o:c.tab.c 
	

c.tab.c:c.y

	bison -dv c.y




clean :
	rm -rf *.c *.h *.o
