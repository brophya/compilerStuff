%{
// Brunet, Matthew
#include <stdio.h>
#include<string.h>
extern int yylex();
%}


%token DO WHILE ENDWHILE IF ENDIF THEN ELSE VAR NUM LT GT LE
%token GE ASSIGN EQ NEQ PLUS MINUS MUL DIV SEMI JUNK RETURN GOTO LABEL
%token OPAREN CPAREN OBRACE CBRACE
%%

prog:   stmts

stmts:  stmt | stmt stmts

stmt:   VAR ASSIGN expression SEMI
	|IF OPAREN relEx CPAREN stmts
	|IF OPAREN relEx CPAREN stmts ELSE stmts
	|WHILE OPAREN relEX  CPAREN stmts
	|OBRACE stmts CBRACE 
        | SEMI



expression : expression PLUS term | expression MINUS term
             | term

term:      term MUL factor | term DIV factor | factor

factor:  OPAREN expression CPAREN 
	| NUM
	| VAR 

relEx: 


%%
int main(){
        yyparse();
}

void yyerror(char *msg){
        printf("\n%s on line %d\n", msg, lineCount);
}
