%{
/* Matthew Brunet,
#include <stdio.h>
#include <string.h>
#include<stdlib.h>
#include "y.tab.h"
extern int numVal;
%}

%%

"do"                    return DO;
"while"                 return WHILE;
"endwhile"              return ENDWHILE;
"if"                    return IF;
"endif"                 return ENDIF;
"then"                  return THEN;
"else"                  return ELSE;
"goto"			return GOTO;
[a-zA-Z]+[a-zA-Z0-9]*:  return LABEL;
[a-zA-Z]+[a-zA-Z0-9]*   return VAR;
[0-9]+[0-9]*            {numVal = atoi(yytext); return NUM;}
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

" "                     ;
"\t"                    ;
"\n"                    {lineCount++;}
[0-9]+[a-zA-Z]*         return JUNK;
.                       return JUNK;

%%
