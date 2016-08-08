all:
	flex -l calc.l
	bison -dv calc.y	
	gcc -o calc calc.tab.c lex.yy.c -lfl

clean:
	rm -rf *o calc *.tab.* lex.yy.c calc.output
