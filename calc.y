%{
#include <stdio.h>
#include <stdlib.h>
#include<string.h>
extern int yylineno;
int yyerror(char *s);
void updateTable(char *symbol, float val, int typ);
float getVAL(char *symbol);
int gettype(char *symbol);
int checkdeclare(char *symbol);

typedef struct{
	char name[20];
	int type;
	float val;
	}sym;

typedef struct{
	int type;
	}exp;
float fval=0.0;
int k=0;

sym s[100];
exp e,e1[10];
%}

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_PRINTLN TOK_MAIN TOK_CLOSE TOK_OPEN TOK_EQUAL TOK_PRINTVAR TOK_INT TOK_FLOAT TOK_DOT

	
%union{ 
        int int_val;
	char *ch_val;
	float float_val;
}

%start prog
/*%type <int_val> expr TOK_NUM*/
//%type <float_val> integer
%type <float_val> expr flt integer
%type <ch_val> stmt
%token <int_val> TOK_NUM
%token <ch_val> TOK_TXT

%left TOK_ADD TOK_SUB
%left TOK_MUL TOK_DIV

%%

prog:
	TOK_MAIN TOK_OPEN stmts TOK_CLOSE
	|{ yyerror("Parsing error.");}
;

stmts:	;
	|stmt TOK_SEMICOLON stmts	
;

stmt: TOK_TXT TOK_EQUAL expr
		{
			int i,dec;
			dec=checkdeclare($1);
			if(dec==1)
			  {
				i=gettype($1);
				if(i==e.type)
	    		  	  {
					updateTable($1,$3,i);
				  }
				else
					yyerror("Type Error.");
			   }
			else
			   {
				printf("Line %d: %s is used but not declared\n ",yylineno,$1); 
				exit(EXIT_SUCCESS);					
			   }	
			k=0;		
		}
	| TOK_INT TOK_TXT 
		{
			//puts($2);
			updateTable($2,0,0);
		}

	|TOK_INT TOK_NUM
		{
			yyerror("Parsing Error.");
		}
	| TOK_FLOAT TOK_TXT 
		{
			updateTable($2,0,1);
		}
	| TOK_PRINTVAR TOK_TXT 
		{
			if(gettype($2)==1)
				printf("Output: %.2f\n",getVAL($2) );
			else
				printf("Output: %.0f\n",getVAL($2) );
		}
	| TOK_PRINTVAR expr
		{
			yyerror("Parsing Error.");
		}
	
;

expr: 	expr TOK_ADD expr
	  {
		if(e1[0].type==e1[1].type)
		  {
			e.type=e1[0].type;
			$$ = $1 + $3;
		  }
		else
	 	  {
			yyerror("Type error.");
		  }
	  }
	| expr TOK_SUB expr
	  {	
		if(e1[0].type==e1[1].type)
		  {
			if($3>$1)
	  		  yyerror("Parsing error.");
			else
			  {
				e.type=e1[0].type;
				$$ = $1 - $3;
			  }
		  }
		else{
			yyerror("Type error.");
		    }
	  }
	| expr TOK_MUL expr
	  {	
		if(e1[0].type==e1[1].type)
		  {
			e.type=e1[0].type;
			$$ = $1 * $3;
		  }
		else
		  {
			yyerror("Type error.");
		  }
	  }
	| expr TOK_DIV expr
	  {
		if(e1[0].type==e1[1].type)
		  {
			if($3==0)
	    		   yyerror("Divide by ZERO error.");
			else
			  {
				e.type=e1[0].type;
				$$ = $1 / $3; 
			  }
		  }
		else
		  {
			yyerror("Type error.");
		  }
	  }
	| integer
	{	
		e.type=0;
		e1[k++].type=0;
	}
		
	| flt 
	{	
		e.type=1;
		e1[k++].type=1;}
	| TOK_TXT
	  {
		$$ = getVAL($1); 
		e.type=gettype($1);
		e1[k++].type=e.type;
	  }
		
	
;

flt: integer TOK_DOT integer
{
		char fh[20],sh[20];
		char *fres;
		sprintf(fh,"%d",(int)$1);
		sprintf(sh,"%d",(int)$3);
		fres = malloc(strlen(fh) + strlen(sh) + 2);
		strcpy(fres,fh);
		strcat(fres,".");
		strcat(fres,sh);
		$$=atof(fres);
}
;

integer: TOK_NUM
	  { 	
		$$ = (float)$1;
	  }
	
;

%%

int yyerror(char *s)
{
	printf("Line %d: %s \n",yylineno, s);
	exit(EXIT_SUCCESS);
}


int getIndex(char *token)
{
	int i;
	for(i=0;i<50;i++)
	{
		if(strcmp(s[i].name,token)==0)
		return i;
		if(strcmp(s[i].name, " 0 ")==0)
		return i;
	}
}
int gettype(char *symbol)
{
	int index = getIndex(symbol);
	return s[index].type;
} 


float getVAL(char *symbol)
{
	int index = getIndex(symbol);
	return s[index].val;
}

int checkdeclare(char *symbol)
{
	int i;
	for(i=0;i<100;i++)
	{
		if(strcmp(s[i].name,symbol)==0)
		return 1;
	}
	return -1;
}

void updateTable(char *symbol,float val, int typ)
{
	int index = getIndex(symbol);
	s[index].val = val;
	s[index].type= typ;
	strcpy(s[index].name, symbol);
	
}

int main()
{
	int i;
	for(i=0; i<100; i++) 
	{
		strcpy(s[i].name, " 0 ");
	}
   yyparse();
   return 0;
}

