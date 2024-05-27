%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "parser.tab.h"
%}

%x LINE_COMMENT
%x MULTILINE_COMMENT
%option yylineno

BOOLEAN true|false
TIP int|double|bool|string
OPERACIJE [-*/+%]

%%
(0|([1-9][0-9]*))|((0x|0X)[1-9A-Fa-f][0-9A-Fa-f]*)      {
                                                            yylval.int_value = atoi(yytext);
                                                            return T_INT;
                                                        }

[0-9]+"."[0-9]*(("E"|"e")("+"|"-")?[0-9]+)?             {
                                                            yylval.double_value = atof(yytext);
                                                            return T_DOUBLE;
                                                        }

0[1-7][0-7]*                                            {
                                                            printf("okt %s\n",yytext);
                                                        }

{BOOLEAN}                           {
                                        if (strcmp(yytext, "true") == 0) {
                                            yylval.bool_value=1;
                                        } else if (strcmp(yytext, "false") == 0) {
                                            yylval.bool_value=0;
                                        } 
                                        return strcmp(yytext, "true") == 0 ? T_TRUE : T_FALSE;
                                    }

{TIP}                               {
                                        printf("tip %s\n", yytext);
                                    }

"if"                                { return T_IF; }
"else"                              { return T_ELSE; }
"while"                             { return T_WHILE; }
"for"                               { return T_FOR; }
"break"                             { return T_BREAK; }

{OPERACIJE}                         {
                                        switch (yytext[0]) {
                                            case '+':
                                                return T_PLUS;
                                            case '-':
                                                return T_MINUS;
                                            case '*':
                                                return T_MULT;
                                            case '/':
                                                return T_DIV;
                                            case '%':
                                                return T_MOD;
                                            default:
                                                yyerror("Unknown operator");
                                                return 0;
                                        }
                                    }

[a-zA-Z][0-9a-zA-Z_]*               {   if(strlen(yytext)<=31){
                                            printf("%s",yytext);
                                        }else{
                                            printf("ID je predugačak, greška u liniji %d\n", yylineno);
                                        }
                                    }

\"([^"\n]|\\.)*\"                   {
                                        printf("STRING %s\n", yytext);
                                    }


"<="                                { return T_LE; }
">="                                { return T_GE; }
"<"                                 { return T_LT; }
">"                                 { return T_GT; }
"=="                                { return T_EQEQ; }
"!="                                { return T_NEQ; }

"!"                                 {
                                        return T_NOT;
                                    }

"="                                 {
                                        printf("=");
                                    }

"&&"                                {
                                        return T_AND;
                                    }

"||"                                {
                                        return T_OR;
                                    }

"("                                 {
                                        return T_LEFTP;
                                    }

")"                                 {
                                        return T_RIGHTP;
                                    }

"{"                                 {
                                        return T_LEFTC;
                                    }

"}"                                 {
                                        return T_RIGHTC;
                                    }

"\\"                                {
                                        printf("%s\n" ,yytext);
                                    }

";"                                 {
                                        return T_SC;
                                    }

[ \t\n]                             { }

"//"                {
                        BEGIN(LINE_COMMENT);
                    }

"/*"                {
                        BEGIN(MULTILINE_COMMENT);
                    }

.                   { }

<LINE_COMMENT>{
"\n"                { BEGIN(INITIAL); } 
"//"|"/*"           { printf("Nije moguce ugnjezdavanje komentara, geška u liniji %d\n",yylineno); }
.                   { }
}

<MULTILINE_COMMENT>{
"*/"                { BEGIN(INITIAL); }
"//"|"/*"           { printf("Nije moguce ugnjezdavanje komentara, geška u liniji %d\n",yylineno); }
.                   { }
"\n"                { }
}

%%
