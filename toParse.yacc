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
char* expressionID;
int tempVal;
int regVals[32]; //this will be used really only if we have too many operands in an expressio
int regPtr = 0;
int operand1;
int operand2;
int labelStack[50]; 
int labelPtr = 0; 
int labelCount = 0;
int ifFlag;
char* compOp;
%}


%token DO WHILE ENDWHILE IF ENDIF THEN ELSE ID NUM LT GT LE
%token GE ASSIGN EQ NEQ PLUS MINUS MUL DIV SEMI JUNK RETURN GOTO COLON
%token OPAREN CPAREN OBRACE CBRACE QM INT CHAR FOR COMMA SGQT IFELSE PUTINTEGER GETINTEGER
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
        | printStatement QM

assignment: varID ASSIGN expression	    { if(getReg(assignID) != -1){printf("move $%d, $%d\n", getReg(assignID), regVals[--regPtr] );regPtr--;} else {printf("sw $%d, %d\n", reg-1, getAdd(assignID)); setReg(assignID, reg-1);} }
            | declaration ASSIGN expression { printf("sw $%d, %d\n", reg-1, getAdd(declareID)); setReg(declareID, reg - 1);}

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
	| expressID   {if(getReg(expressionID) == -1) {printf("lw $%d, %d\n", reg, getAdd(identifier)); regVals[regPtr++] = reg++;}else regVals[regPtr++] = getReg(expressionID); } 
        | getIntegerFunct {printf("move $%d, $2\n", reg); regVals[regPtr++] = reg++; }

expressID: ID {expressionID = strdup(identifier); if(lookUp(identifier) == NULL) yyerror("use of undeclared variable"); }

type:  INT      {varType = "int" ;} 
        | CHAR  {varType = "char" ;}

condition: expression op expression {operand2 = regVals[regPtr - 1]; operand1 = regVals[regPtr - 2]; 
                                    printf("%s $%d, $%d, endLabel%d\n",compOp, operand1, operand2, labelStack[labelPtr - 1]);}

condition2:expression op expression {operand2 = regVals[regPtr - 1]; operand1 = regVals[regPtr - 2]; 
                          if(ifFlag == 0) {printf("%s $%d, $%d, ifLabel%d\n",compOp, operand1, operand2, labelStack[labelPtr++] = labelCount++);} 
                          else{ labelStack[labelPtr++] = labelCount++; labelStack[labelPtr++] = labelCount++;
                          printf("%s $%d, $%d, ifLabel%d\n",compOp, operand1, operand2, labelStack[labelPtr - 2]);}}         
                 

condition4:


op:     LT      {compOp = "bge";}
        | GT    {compOp = "ble";}
        | LE    {compOp = "bgt";}
        | GE    {compOp = "blt";}
        | EQ    {compOp = "bne";}
        | NEQ   {compOp = "beq";}

if:     ifCond OPAREN condition2 CPAREN OBRACE stmts CBRACE {printf("ifLabel%d: \n",labelStack[labelPtr-1]); labelPtr--;}

ifCond: IF {ifFlag = 0;}

ifElse: ifElseCond OPAREN condition2 CPAREN OBRACE stmts CBRACE else OBRACE stmts CBRACE {printf("ifLabel%d: \n",labelStack[labelPtr-1]);
                                                                                  labelPtr = labelPtr - 2; ifFlag = 0;}
ifElseCond: IFELSE {ifFlag = 1;}

else: ELSE {printf("j ifLabel%d \n",labelStack[labelPtr-1]); printf("ifLabel%d: \n",labelStack[labelPtr-2]);}


whileStatement: while OPAREN condition CPAREN OBRACE stmts CBRACE  {labelPtr--; 
                                                 printf("j label%d\n endLabel%d:  \n", labelStack[labelPtr], labelStack[labelPtr]);}

while: WHILE {printf("label%d:  \n", labelCount); labelStack[labelPtr++] = labelCount++;}  

forStatement: FOR OPAREN assignment QM condition4 QM assignment CPAREN OBRACE stmts CBRACE 

printStatement: PUTINTEGER OPAREN NUM CPAREN     {printf("li $2, 1\n"); printf("li $4, %d\n", numVal); printf("syscall\n");}
                | PUTINTEGER OPAREN varID CPAREN {if (strcmp((lookUp(assignID)->type),"int") != 0) yyerror("invalid parameter for putInt");
                                               else printf("li $2, 1\n"); printf("lw $4, %d\n", getAdd(assignID)); printf("syscall\n");}  

getIntegerFunct:   GETINTEGER OPAREN CPAREN {printf("li $2, 5\nsyscall\n");}


%%
int main(){
        yyparse();
}

void yyerror(char *msg){
        printf("\n%s on line %d\n", msg, lineCount);
        exit(-1);
}
