/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    DO = 258,
    WHILE = 259,
    ENDWHILE = 260,
    IF = 261,
    ENDIF = 262,
    THEN = 263,
    ELSE = 264,
    VAR = 265,
    NUM = 266,
    LT = 267,
    GT = 268,
    LE = 269,
    GE = 270,
    ASSIGN = 271,
    EQ = 272,
    NEQ = 273,
    PLUS = 274,
    MINUS = 275,
    MUL = 276,
    DIV = 277,
    SEMI = 278,
    JUNK = 279,
    RETURN = 280,
    GOTO = 281,
    LABEL = 282,
    OPAREN = 283,
    CPAREN = 284,
    OBRACE = 285,
    CBRACE = 286,
    QM = 287,
    EXPON = 288
  };
#endif
/* Tokens.  */
#define DO 258
#define WHILE 259
#define ENDWHILE 260
#define IF 261
#define ENDIF 262
#define THEN 263
#define ELSE 264
#define VAR 265
#define NUM 266
#define LT 267
#define GT 268
#define LE 269
#define GE 270
#define ASSIGN 271
#define EQ 272
#define NEQ 273
#define PLUS 274
#define MINUS 275
#define MUL 276
#define DIV 277
#define SEMI 278
#define JUNK 279
#define RETURN 280
#define GOTO 281
#define LABEL 282
#define OPAREN 283
#define CPAREN 284
#define OBRACE 285
#define CBRACE 286
#define QM 287
#define EXPON 288

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
