
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     T_INT = 258,
     T_DOUBLE = 259,
     T_TRUE = 260,
     T_FALSE = 261,
     T_STRING = 262,
     T_ID = 263,
     T_LET = 264,
     T_IN = 265,
     T_EQ = 266,
     T_SC = 267,
     T_END = 268,
     INT = 269,
     DOUBLE = 270,
     BOOL = 271,
     STRING = 272,
     T_PLUS = 273,
     T_MINUS = 274,
     T_MULT = 275,
     T_DIV = 276,
     T_MOD = 277,
     T_LT = 278,
     T_GT = 279,
     T_LE = 280,
     T_GE = 281,
     T_EQEQ = 282,
     T_NEQ = 283,
     T_AND = 284,
     T_OR = 285,
     T_NOT = 286,
     T_LEFTP = 287,
     T_RIGHTP = 288,
     T_LEFTC = 289,
     T_RIGHTC = 290,
     T_LEFTS = 291,
     T_RIGHTS = 292,
     T_IF = 293,
     T_ELSE = 294,
     T_WHILE = 295,
     T_FOR = 296,
     T_BREAK = 297,
     T_CONTINUE = 298,
     T_DO = 299,
     T_THEN = 300,
     T_RETURN = 301,
     T_READ = 302,
     T_WRITE = 303,
     T_SKIP = 304
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 8 "parser.y"

    int int_value;
    double double_value;
    char* ident;
    int bool_value;



/* Line 1676 of yacc.c  */
#line 110 "parser.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


