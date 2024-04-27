%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
%}

%x LINE_COMMENT
%x MULTILINE_COMMENT
%option yylineno

KEYWORD IF|ELSE|WHILE|FOR|BREAK
BOOLEAN TRUE|FALSE
TIP INT|DOUBLE|BOOL|STRING
OPERACIJE [-*/+%]

%%
(0|([1-9][0-9]*))|((0x|0X)[1-9A-Fa-f][0-9A-Fa-f]*)      {
                                                            printf("INT %s\n",yytext);
                                                        }

[0-9]+"."[0-9]*(("E"|"e")("+"|"-")?[0-9]+)?             {
                                                            printf("DOUBLE %s\n",yytext);
                                                        }

0[1-7][0-7]*                                            {
                                                            printf("OKT %s\n",yytext);
                                                        }

{BOOLEAN}                           {
                                        printf("%s\n", yytext);
                                    }

{TIP}                               {
                                        printf("tip %s\n", yytext);
                                    }

{KEYWORD}                           {
                                        printf("%s\n",yytext);
                                    }

{OPERACIJE}                         {
                                        printf("%s\n", yytext);
                                    }

[a-zA-Z][0-9a-zA-Z_]*               {   if(strlen(yytext)<=31){
                                            printf("ID %s\n",yytext);
                                        }else{
                                            printf("ID je predugačak, greška u liniji %d\n", yylineno);
                                        }
                                    }

\"([^"\n]|\\.)*\"                   {
                                        printf("STRING %s\n", yytext);
                                    }

"<="|">="|"<"|">"|"=="|"!="         {
                                        printf("Poredjenje %s\n",yytext);
                                    }

\!                                  {
                                        printf("NOT\n");
                                    }

"="                                 {
                                        printf("=\n");
                                    }

"&&"                                {
                                        printf("AND\n");
                                    }

"||"                                {
                                        printf("OR\n");
                                    }

"("                                 {
                                        printf("%s\n" ,yytext);
                                    }

")"                                 {
                                        printf("%s\n" ,yytext);
                                    }

"\\"                                {
                                        printf("%s\n" ,yytext);
                                    }

";"|","|"."                         { }

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

int main(){
    yylex();
    return 0;
}