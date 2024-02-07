%{
#include <stdio.h>
#include<string.h>
extern int yylex();
int lineCount = 0;
int numVal;
%}


%token DO WHILE ENDWHILE IF ENDIF THEN ELSE VAR NUM LT GT LE
%token GE ASSIGN EQ NEQ PLUS MINUS MUL DIV SEMI JUNK RETURN GOTO LABEL
%token OPAREN CPAREN OBRACE CBRACE
%%

prog:   stmts

stmts:  stmt | stmt stmts

stmt:   VAR ASSIGN expression SEMI
	|OBRACE stmts CBRACE 
        | SEMI



expression : expression PLUS term | expression MINUS term
             | term

term:      term MUL factor | term DIV factor | factor

factor:  OPAREN expression CPAREN 
	| NUM
	| VAR 



%%
int main(){
        yyparse();
}

void yyerror(char *msg){
        printf("\n%s on line %d\n", msg, lineCount);
}
