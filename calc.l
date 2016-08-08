%{

#include <stdio.h>
#include "calc.tab.h"

%}
%option yylineno

digit	([0-9])

txt	([a-zA-Z])

%%



"println"       {       return(TOK_PRINTLN);	}

"printvar"	{	return(TOK_PRINTVAR); 	}



"main()"	{	return(TOK_MAIN); 	}
"{"	{	return(TOK_OPEN); 	}
"}"		{	return(TOK_CLOSE); 	}
"int"		{	return(TOK_INT); 	}
"float"		{	return(TOK_FLOAT);	}


";"	{	return(TOK_SEMICOLON);	}

"+"	{	return(TOK_ADD);	}

"-"	{	return(TOK_SUB);	}

"*"	{	return(TOK_MUL);	}

"/"	{	return(TOK_DIV);	}

"="	{	return(TOK_EQUAL);	}

"."	{ return(TOK_DOT);}

{digit}+	{

		sscanf(yytext, "%d", &yylval.int_val);

		return TOK_NUM;

		}



{txt}+		{
		char *res = malloc(strlen(yytext) + 1);
		strcpy(res, yytext);
		yylval.ch_val = res;
		return TOK_TXT;
		}






[ \t\n] 	{}



.	{printf("Invalid character '%c', ignored\n", 

			yytext[0]);

	}



%%
