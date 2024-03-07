%{	
#include "symbolTable.h"
#include <stdio.h>
#include<string.h>
extern int yylex();
void yyerror(char*);
int lineCount = 0;
extern char* yytext;
int numVal;
int reg = 8;
char* identifier;
char* varType;
char* assignID;
char* declareID;
int tempVal;
int regVals[32]; //this will be used really only if we have too many operands in an expressio
int regPtr = 0;
int operand1;
int operand2;
int labelStack[50]; 
int labelPtr = 0; 
int labelCount = 0;
char* compOp;
%}


%token DO WHILE ENDWHILE IF ENDIF THEN ELSE ID NUM LT GT LE
%token GE ASSIGN EQ NEQ PLUS MINUS MUL DIV SEMI JUNK RETURN GOTO COLON
%token OPAREN CPAREN OBRACE CBRACE QM INT CHAR FOR COMMA SGQT
%%

prog:   stmts

stmts:  stmt | stmt stmts

stmt:   assignment QM   
        | declaration QM
        | gotoStatement QM
        | labeledStatement    
	|OBRACE stmts CBRACE 
        | QM
	| ifElse
	| if
        | whileStatement 
        | forStatement

assignment: varID ASSIGN expression	    { printf("sw $%d, %s\n", reg-1, assignID);}
            | declaration ASSIGN expression { printf("sw $%d, %s\n", reg-1, declareID);}

varID: ID {assignID = strdup(identifier); if (lookUp(identifier) == NULL) yyerror("use of undeclared variable"); }

declaration: type ID {install(identifier, varType); declareID = strdup(identifier);} 
 
gotoStatement: GOTO ID

labeledStatement: ID COLON stmt

expression : expression PLUS term   {operand2 = regVals[--regPtr]; operand1 = regVals[--regPtr]; regVals[regPtr] = reg++; printf("add $%d, $%d, $%d\n", regVals[regPtr++], operand1, operand2);}
             | expression MINUS term {operand2 = regVals[--regPtr]; operand1 = regVals[--regPtr]; regVals[regPtr] = reg++; printf("sub $%d, $%d, $%d\n", regVals[regPtr++], operand1, operand2);}
             | term

term:      term MUL factor   {operand2 = regVals[--regPtr]; operand1 = regVals[--regPtr]; regVals[regPtr] = reg++; printf("mul $%d, $%d, $%d\n", regVals[regPtr++], operand1, operand2);}
           | term DIV factor {operand2 = regVals[--regPtr]; operand1 = regVals[--regPtr]; regVals[regPtr] = reg++; printf("div $%d, $%d, $%d\n", regVals[regPtr++], operand1, operand2);}
           | factor 

factor:  OPAREN expression CPAREN   
	| NUM  {printf("li $%d, %d\n", reg, numVal); regVals[regPtr++] = reg++; }  
	| ID   {printf("lw $%d, %s\n", reg, identifier); regVals[regPtr++] = reg++; } 

type:  INT      {varType = "int" ;} 
        | CHAR  {varType = "char" ;}

condition: expression op expression {operand2 = regVals[regPtr - 1]; operand1 = regVals[regPtr - 2]; 
                                    printf("%s $%d, $%d, endLabel%d\n",compOp, operand1, operand2, labelStack[labelPtr - 1]);}

condition2:expression op expression {operand2 = regVals[regPtr - 1]; operand1 = regVals[regPtr - 2]; 
                          printf("%s $%d, $%d, endLabel%d\n",compOp, operand1, operand2, labelStack[labelPtr++] = labelCount++);}

op:	LT      {compOp = "bge";} 
        | GT    {compOp = "ble";}
        | LE    {compOp = "bgt";}
        | GE    {compOp = "blt";}
        | EQ    {compOp = "bne";}
        | NEQ   {compOp = "beq";}

if:     IF OPAREN condition2 CPAREN OBRACE stmts CBRACE {printf("endLabel%d: \n",labelStack[labelPtr-1]);}

ifElse: IF OPAREN condition2 CPAREN OBRACE stmts CBRACE else OBRACE stmts CBRACE {printf("endIf%d: \n",labelStack[labelPtr-1]);}

else: ELSE {printf("j endIf%d \n",labelStack[labelPtr-1]); printf("endLabel%d: \n",labelStack[labelPtr-1]);}

whileStatement: while OPAREN condition CPAREN OBRACE stmts CBRACE  {labelPtr--; 
                                                 printf("j label%d\n endLabel%d:  \n", labelStack[labelPtr], labelStack[labelPtr]);}

while: WHILE {printf("label%d:  \n", labelCount); labelStack[labelPtr++] = labelCount++;}  

forStatement: FOR OPAREN assignment QM condition QM assignment CPAREN OBRACE stmts CBRACE 


%%
int main(){
        yyparse();
}

void yyerror(char *msg){
        printf("\n%s on line %d\n", msg, lineCount);
        exit(-1);
}
