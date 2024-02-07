lex.yy.c y.tab.h: lexical.lex
	lex lexical.lex
y.tab.c: toParse.yacc
	yacc -d toParse.yacc
compile: y.tab.c lex.yy.c
	cc y.tab.c lex.yy.c -ll -ly -o compile
clean:
	rm -f compile 
	rm -f *.o

cleanwin:
	del -f compile.exe
	del -f *.o
