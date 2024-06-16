%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #include "errors.h"
    #include "errors.c"
    #include "parser.tab.h"

    int yycolumn=1;
%}

%x LINE_COMMENT
%x MULTILINE_COMMENT
%option yylineno


%%

(0|([1-9][0-9]*))|((0x|0X)[1-9A-Fa-f][0-9A-Fa-f]*)      {
                                                            yylval.int_value = atoi(yytext);
                                                            yycolumn += strlen(yytext);
                                                            return T_INT;
                                                        }

[0-9]+"."[0-9]*(("E"|"e")("+"|"-")?[0-9]+)?             { 
                                                            yylval.double_value = atof(yytext);
                                                            yycolumn += strlen(yytext);
                                                            return T_DOUBLE;
                                                        }

"+"                                 { yycolumn++; return T_PLUS; }
"-"                                 { yycolumn++; return T_MINUS; }
"*"                                 { yycolumn++; return T_MULT; }
"/"                                 { yycolumn++; return T_DIV; }
"%"                                 { yycolumn++; return T_MOD; }

"TRUE"                              { yylval.bool_value = 1; yycolumn += strlen(yytext); return T_TRUE; }
"FALSE"                             { yylval.bool_value = 0; yycolumn += strlen(yytext); return T_FALSE; }

"INT"                               { yycolumn += strlen(yytext); return INT; }
"DOUBLE"                            { yycolumn += strlen(yytext); return DOUBLE; }
"BOOL"                              { yycolumn += strlen(yytext); return BOOL; }
"STRING"                            { yycolumn += strlen(yytext); return STRING; }

"IF"                                { yycolumn += strlen(yytext); return T_IF; }
"THEN"                              { yycolumn += strlen(yytext); return T_THEN; }
"ELSE"                              { yycolumn += strlen(yytext); return T_ELSE; }
"WHILE"                             { yycolumn += strlen(yytext); return T_WHILE; }
"DO"                                { yycolumn += strlen(yytext); return T_DO; }
"FOR"                               { yycolumn += strlen(yytext); return T_FOR; }
"BREAK"                             { yycolumn += strlen(yytext); return T_BREAK; }
"READ"                              { yycolumn += strlen(yytext); }
"WRITE"                             { yycolumn += strlen(yytext); }

"LET"                               { yycolumn += strlen(yytext); return T_LET; }
"IN"                                { yycolumn += strlen(yytext); return T_IN;}
"END"                               { yycolumn += strlen(yytext); return T_END; }
"SKIP"                              { yycolumn += strlen(yytext); }

[a-zA-Z][0-9a-zA-Z_]*               {   if(strlen(yytext)<=31){
                                            //yylval.ident=strdup(yytext);
                                            yycolumn += strlen(yytext);
                                            return T_ID;
                                        }else{
                                            yycolumn += strlen(yytext);
                                            invalid_ident(yylineno, yycolumn);
                                        }
                                    }

\"([^"\n]|\\.)*\"                   {
                                        yylval.ident=yytext;
                                        yycolumn += strlen(yytext);
                                        return T_STRING;
                                    }


"<="                                { yycolumn += strlen(yytext); return T_LE; }
">="                                { yycolumn += strlen(yytext); return T_GE; }
"<"                                 { yycolumn += strlen(yytext); return T_LT; }
">"                                 { yycolumn += strlen(yytext); return T_GT; }
"=="                                { yycolumn += strlen(yytext); return T_EQEQ; }
"!="                                { yycolumn += strlen(yytext); return T_NEQ; }

"!"                                 { yycolumn++; return T_NOT; }

"="                                 { yycolumn++; return T_EQ; }

"&&"                                { yycolumn += strlen(yytext); return T_AND; }

"||"                                { yycolumn += strlen(yytext); return T_OR; }

"("                                 { yycolumn++; return T_LEFTP; }

")"                                 { yycolumn++; return T_RIGHTP; }

"{"                                 { yycolumn++; return T_LEFTC; }

"}"                                 { yycolumn++; return T_RIGHTC; }

"["                                 { yycolumn++; return T_LEFTS; }

"]"                                 { yycolumn++; return T_RIGHTS; }

";"                                 { yycolumn++; return T_SC; }

[ \t\n]                             { yycolumn += strlen(yytext); }

"//"                {
                        BEGIN(LINE_COMMENT);
                    }

"/*"                {
                        BEGIN(MULTILINE_COMMENT);
                    }

(0x|0X)[^0-9a-fA-F]             { yycolumn += strlen(yytext); invalid_int(yylineno, yycolumn); }

"0"[0-9]*                       { yycolumn += strlen(yytext); invalid_int(yylineno, yycolumn); }

"\""([^"\n]|\\.)*\"            { yycolumn += strlen(yytext); invalid_string(yylineno, yycolumn); }


.                   { }

<LINE_COMMENT>{
"\n"                { BEGIN(INITIAL); } 
"//"|"/*"           { invalid_comment(yylineno); }
.                   { }
}

<MULTILINE_COMMENT>{
"*/"                { BEGIN(INITIAL); }
"//"|"/*"           { invalid_comment(yylineno); }
.                   { }
"\n"                { yycolumn=1; }
}

%%
