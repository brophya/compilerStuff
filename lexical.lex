%{
#include <stdio.h>
#include <string.h>
#include<stdlib.h>
#include "y.tab.h"
extern int lineCount; 
extern int numVal;
extern char* identifier; 
extern char* varType;
%}

%%
"getInteger"            return GETINTEGER;
"putInteger"            return PUTINTEGER;
"do"                    return DO;
"while"                 return WHILE;
"if"                    return IF;
"ifelse"                return IFELSE;
"then"                  return THEN;
"else"                  return ELSE;
"goto"			return GOTO;
"int"                   {varType = "int"; return INT;}
"char"                  {varType = "char"; return CHAR;}
"for"                   return FOR;
","                     return COMMA; 
":"                     return COLON; 
"'"                     return SGQT;
[a-zA-Z]+[a-zA-Z0-9]*   {identifier = strdup( yytext); return ID;}
[0-9]+                  {numVal = atoi(yytext); return NUM;}
[-][0-9]+               {numVal = atoi(yytext); return NUM;}
"{"			return OBRACE;
"}"			return CBRACE;
"("			return OPAREN;
")"                     return CPAREN;                  
"<"                     return LT;
">"                     return GT;
"<="                    return LE;
">="                    return GE;
"="                     return ASSIGN;
"=="                    return EQ;
"!="                    return NEQ;
"+"                     return PLUS;
"-"                     return MINUS;
";"                     return SEMI;
"*"                     return MUL;
"/"                     return DIV;
"?"                     return QM;
" "                     ;
"\t"                    ;
"\n"                    {lineCount++;}
[0-9]+[a-zA-Z]*         return JUNK;
.                       return JUNK;

%%

