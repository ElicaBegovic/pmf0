%{
    #include <stdlib.h> 
    #include <stdio.h>

    struct Promenljiva {
        char *id;
        int val;
    };

    void yyerror(const char* s);
    struct Promenljiva tabela_simbola[50];
%}

%union {
    int int_value;
    double double_value;
    char* ident;
    int bool_value;
}

%start S
%token <int_value> T_INT
%token <double_value> T_DOUBLE
%token T_SC
%token T_PLUS T_MINUS T_MULT T_DIV T_MOD
%token T_LT T_GT T_LE T_GE T_EQEQ T_NEQ
%token <bool_value> T_TRUE T_FALSE
%token T_AND T_OR T_NOT
%token T_LEFTP T_RIGHTP T_LEFTC T_RIGHTC
%token <ident> T_ID
%token T_IF T_ELSE T_WHILE T_FOR T_BREAK
%token T_EQ

%right T_EQ
%left T_OR T_AND
%nonassoc T_EQEQ T_NEQ
%nonassoc T_LT T_GT T_LE T_GE
%left T_PLUS T_MINUS
%left T_MULT T_DIV T_MOD
%right T_NOT

%type <int_value> int_exp
%type <double_value> double_exp
%type <bool_value> comp_exp
%type <bool_value> bool_exp
%type <int_value> stat

%%
S: S stat                         { }
    | //prazna rec
;

stat: int_exp T_SC { printf("%d\n", $1); } 
    | double_exp T_SC { printf("%f\n", $1); } 
    | comp_exp T_SC { printf("%s\n", $1 ? "True" : "False"); }
    | bool_exp T_SC { printf("%s\n", $1 ? "True" : "False"); }
    | T_IF T_LEFTP bool_exp T_RIGHTP T_LEFTC stat T_RIGHTC  { if ($3==1) { $$ = $6; } }
    | T_ID T_EQ int_exp T_SC  { }
    | T_ID T_EQ double_exp T_SC  { }
    | T_ID T_EQ comp_exp T_SC  { }
    | T_ID T_EQ bool_exp T_SC { }
;

int_exp: T_INT { $$ = $1; }
    | int_exp T_PLUS int_exp { $$ = $1 + $3; }
    | int_exp T_MINUS int_exp { $$ = $1 - $3; }
    | int_exp T_MULT int_exp { $$ = $1 * $3; }
    | int_exp T_DIV int_exp { $$ = $1 / $3; }
    | int_exp T_MOD int_exp { $$ = $1 % $3; }
    | T_LEFTP int_exp T_RIGHTP { $$ = $2; }
;

double_exp: T_DOUBLE { $$ = $1; }
    | double_exp T_PLUS double_exp { $$ = $1 + $3; }
    | double_exp T_MINUS double_exp { $$ = $1 - $3; }
    | double_exp T_MULT double_exp { $$ = $1 * $3; }
    | double_exp T_DIV double_exp { $$ = $1 / $3; }
    | T_LEFTP double_exp T_RIGHTP { $$ = $2; }
;

comp_exp: T_INT { $$ = $1; } //dodato za vise
    | T_DOUBLE { $$ = $1; } //dodato za vise
    | int_exp T_LT int_exp { $$ = $1 < $3 ? 1 : 0; } // poređenje za int
    | int_exp T_GT int_exp { $$ = $1 > $3 ? 1 : 0; }
    | int_exp T_LE int_exp { $$ = $1 <= $3 ? 1 : 0; }
    | int_exp T_GE int_exp { $$ = $1 >= $3 ? 1 : 0; }
    | int_exp T_EQEQ int_exp { $$ = $1 == $3 ? 1 : 0; }
    | int_exp T_NEQ int_exp { $$ = $1 != $3 ? 1 : 0; }
    | double_exp T_LT double_exp { $$ = $1 < $3 ? 1 : 0; } // poređenja za double
    | double_exp T_GT double_exp { $$ = $1 > $3 ? 1 : 0; }
    | double_exp T_LE double_exp { $$ = $1 <= $3 ? 1 : 0; }
    | double_exp T_GE double_exp { $$ = $1 >= $3 ? 1 : 0; }
    | double_exp T_EQEQ double_exp { $$ = $1 == $3 ? 1 : 0; }
    | double_exp T_NEQ double_exp { $$ = $1 != $3 ? 1 : 0; }
    | comp_exp T_LT comp_exp { $$ = $1 && $3 ? 1 : 0; } // poređenja za vise
    | comp_exp T_GT comp_exp { $$ = $1 && $3 ? 1 : 0; }
    | comp_exp T_LE comp_exp { $$ = $1 && $3 ? 1 : 0; }
    | comp_exp T_GE comp_exp { $$ = $1 && $3 ? 1 : 0; }
    | comp_exp T_EQEQ comp_exp { $$ = $1 && $3 ? 1 : 0; }
    | comp_exp T_NEQ comp_exp { $$ = $1 && $3 ? 1 : 0; }
    | T_LEFTP comp_exp T_RIGHTP { $$ = $2; }
;

bool_exp: T_TRUE { $$ = $1; }
    | T_FALSE { $$ = $1; }
    | comp_exp { $$ = $1; }
    | bool_exp T_AND bool_exp { $$ = $1 && $3; }
    | bool_exp T_OR bool_exp { $$ = $1 || $3; }
    | T_NOT bool_exp { $$ = !$2; }
    | T_LEFTP bool_exp T_RIGHTP { $$ = $2; }
    
;

%%

void yyerror(const char* s){
    printf("%s\n", s);
}

int main(){
    int res = yyparse();    
    if(res == 0){
        printf("Ulaz je ispravan!\n");
    }
    else{
        printf("Ulaz nije ispravan!\n");
    }

    return 0;
}