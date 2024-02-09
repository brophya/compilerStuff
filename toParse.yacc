%{
#include <stdio.h>
#include<string.h>
extern int yylex();
void yyerror(char*);
int lineCount = 0;
int numVal;

%}


%token DO WHILE ENDWHILE IF ENDIF THEN ELSE ID NUM LT GT LE
%token GE ASSIGN EQ NEQ PLUS MINUS MUL DIV SEMI JUNK RETURN GOTO COLON
%token OPAREN CPAREN OBRACE CBRACE QM INT CHAR
%%

prog:   stmts

stmts:  stmt | stmt stmts

stmt:   assignment QM
        | declaration QM
        | gotoStatement QM
        | labeledStatement QM    
	|OBRACE stmts CBRACE 
        | QM

assignment: ID ASSIGN expression
            | declaration ASSIGN expression

declaration: type ID 

gotoStatement: GOTO ID

labeledStatement: ID COLON stmt

expression : expression PLUS term | expression MINUS term
             | term

term:      term MUL factor | term DIV factor | factor

factor:  OPAREN expression CPAREN 
	| NUM
	| ID 

type:  INT 
        | CHAR 
  
%%
int main(){
        yyparse();
}

void yyerror(char *msg){
        printf("\n%s on line %d\n", msg, lineCount);
}
