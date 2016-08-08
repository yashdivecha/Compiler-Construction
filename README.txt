
Developed a Compiler, based on Context Free Grammar (CFG) that performs 
arithmetic operations (calculator) as well as lexical analysis,parsing and semantic analysis (type checking).

<Flex and Bison>
_________________________________________________________________________________________________________________________

To execute the program, use below steps:
Step 1: Traverse to the path where the make file is located.
bingsuns2% cd pl-ydivech1

Step 2: Type "make" to compile Flex, Bison and creates output executable file in "calc".
bingsuns2% make
-------------------------------------------
flex -l calc.l
bison -dv calc.y
gcc calc.tab.c lex.yy.c -o calc -lfl
-------------------------------------------
Additionally we have created make clean which cleans all the output files in the current directory. 
bingsuns2% make clean
-------------------------------------------
rm -rf *o calc *.tab.* lex.yy.c calc.output
-------------------------------------------

Step 3: Execute the output file calc and you can use input file as your test cases. 
bingsuns2% ./calc <input.txt
_________________________________________________________________________________________________________________________

ALGORITHM: 

Parsing Rules
Prog: main() { Stmts }....................String Accepted
	| 		..................ERROR

Stmts : ; 
	| Stmt; Stmts  ...................String Accepted

Stmt : int TOK_TXT ....................... update symbol table with [Variable, Type]
	| float TOK_TXT .................. update symbol table with [Variable, Type]
	| TOK_TXT = expr ................. Assigns the value of expression, Update Symbol Table with [Value, Type]
	| printvar TOK_TXT ............... Print variable's value.

expr : 	Integer  ......................... Sets integer type as ZERO (0).
	| Float  ......................... Sets integer type as ONE (1).
	| TOK_TXT ........................ Fetches the value from Symbol Table.
	| expr + expr  ................... Performs addition. 
	| expr * expr  ................... Performs multiplication.

Integer : digit+ ......................... Input integers. [0-9]

Float : Integer . Integer ................ Input floating values. [0-9].[0-9]
_________________________________________________________________________________________________________________________

Type Checking Rules: 
--> Used 2 Structures to store variable type and non-terminal type.
--> Struct sym s[100]
--> Struct exp e, e[10]
 
Stmt -> int TOK_TXT | 				{s[index(TOK_TXT)].type = 0}
	float TOK_TXT | 				{ s[index(TOK_TXT)].type = 1}
	TOK_TXT = expr 					{if (s[index(TOK_TXT)].type \= e.type) then type error}

expr : 	Integer | 					{e.type = 0, e[i++].type = 0}
	Float | 						{e.type = 1, e[i++].type = 1}
	TOK_TXT | 						{e.type = s[index(TOK_TXT)].type}
	E1 + E2| 						{if (e[0].type==e[1].type) then e.type = e[0].type; else type error}
	E1 * E2 | 						{if (e[0].type==e[1].type) then e.type = e[0].type; else type error}
_________________________________________________________________________________________________________________________

