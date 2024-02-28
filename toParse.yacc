%{	
#include "symbolTable.h"
#include <stdio.h>
#include<string.h>
extern int yylex();
void yyerror(char*);
int lineCount = 0;
int numVal;
int reg = 1;
char* identifier;
char* varType;
int tempVal;
%}


%token DO WHILE ENDWHILE IF ENDIF THEN ELSE ID NUM LT GT LE
%token GE ASSIGN EQ NEQ PLUS MINUS MUL DIV SEMI JUNK RETURN GOTO COLON
%token OPAREN CPAREN OBRACE CBRACE QM INT CHAR FOR COMMA SGQT
%%

prog:   stmts

stmts:  stmt | stmt stmts

stmt:   assignment QM    {printf("MOV %s, R%d\n",identifier,reg-1);}
        | declaration QM
        | gotoStatement QM
        | labeledStatement    
	|OBRACE stmts CBRACE 
        | QM
	| ifElse
	| if
        | whileStatement 
        | forStatement

assignment: ID ASSIGN expression	    { printf("MOV R%d, %d\n",reg++, $3);}
            | declaration ASSIGN expression { printf("MOV R%d, %d\n", reg++,$3);}

declaration: type ID {install(identifier, varType); printf("INSTALLED     NAME: %s  TYPE: %s\n", lookUp(identifier)->name, lookUp(identifier)->type); } 

gotoStatement: GOTO ID

labeledStatement: ID COLON stmt

expression : expression PLUS term { $$ = $1 + $3; }
             | expression MINUS term { $$ = $1 - $3; }
             | term {$$ = $1;}

term:      term MUL factor {$$ = $1 * $3;} 
           | term DIV factor {$$ = $1 / $3;}
           | factor {$$ = $1;}

factor:  OPAREN expression CPAREN {$$ = $2;} 
	| NUM   {$$ = numVal;}
	| ID 

type:  INT 
        | CHAR 

condition: expression op expression

op:	LT | GT | LE | GE | EQ | NEQ

ifElse: IF OPAREN condition CPAREN OBRACE stmts CBRACE ELSE OBRACE stmts CBRACE

if:	IF OPAREN condition CPAREN OBRACE stmts CBRACE

whileStatement: WHILE OPAREN condition CPAREN OBRACE stmts CBRACE  

forStatement: FOR OPAREN assignment QM condition QM assignment CPAREN OBRACE stmts CBRACE 


%%
int main(){
        yyparse();
}

void yyerror(char *msg){
        printf("\n%s on line %d\n", msg, lineCount);
}
