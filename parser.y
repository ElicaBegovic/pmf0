%{
    #include <stdlib.h> 
    #include <stdio.h>

    void yyerror(const char* s);
%}

%union {
    int int_value;
    double double_value;
    char* ident;
    int bool_value;
}
%token <int_value> T_INT
%token <double_value> T_DOUBLE
%token <bool_value> T_TRUE T_FALSE
%token <ident> T_STRING

%token T_ID

%token T_LET T_IN T_EQ T_SC T_END 
%token INT DOUBLE BOOL STRING 
%token T_PLUS T_MINUS T_MULT T_DIV T_MOD
%token T_LT T_GT T_LE T_GE T_EQEQ T_NEQ
%token T_AND T_OR T_NOT

%token T_LEFTP T_RIGHTP T_LEFTC T_RIGHTC T_LEFTS T_RIGHTS
%token T_IF T_ELSE T_WHILE T_FOR T_BREAK T_CONTINUE T_DO T_THEN T_RETURN
%token T_READ T_WRITE T_SKIP

%right T_EQ
%left T_OR T_AND
%nonassoc T_EQEQ T_NEQ
%nonassoc T_LT T_GT T_LE T_GE
%left T_PLUS T_MINUS
%left T_MULT T_DIV T_MOD
%right T_NOT

%start program

%%
program: T_LET T_LEFTS declarations T_RIGHTS T_IN statements T_END 
;

/*declarations*/
declarations: declarations declaration 
            | declaration 
            ;

declaration: type T_ID T_SC 
           ;

type: INT 
    | STRING 
    | DOUBLE 
    | BOOL 
    ;

/*statements*/
statements: statements statement 
          | statement 
          ;

statement: expression T_SC 
         | if_exp 
         | for_exp 
         | while_exp 
         | assignment T_SC 
         
         ;

assignment: T_ID T_EQ expression 
          ;

if_exp: T_IF T_LEFTP expression T_RIGHTP tail else_if optional_else 
      | T_IF T_LEFTP expression T_RIGHTP tail optional_else 
      ;

else_if: else_if T_ELSE T_IF T_LEFTP expression T_RIGHTP tail 
       | T_ELSE T_IF T_LEFTP expression T_RIGHTP tail 
       ;

optional_else: T_ELSE tail 
             | /* empty */ 
             ;

for_exp: T_FOR T_LEFTP assignment T_SC expression T_SC expression T_RIGHTP tail 
       ;

while_exp: T_WHILE T_LEFTP expression T_RIGHTP tail 
         ;

tail: T_LEFTC statements T_RIGHTC 
    ;

/*expressions*/
expression: int_exp 
          | double_exp 
          | bool_exp 
          | comp_exp 
          ;

int_exp: int_exp T_PLUS int_exp 
       | int_exp T_MINUS int_exp 
       | int_exp T_MULT int_exp 
       | int_exp T_DIV int_exp 
       | int_exp T_MOD int_exp 
       | T_LEFTP int_exp T_RIGHTP 
       | T_INT
       ;

double_exp: T_DOUBLE 
          | double_exp T_PLUS double_exp 
          | double_exp T_MINUS double_exp 
          | double_exp T_MULT double_exp 
          | double_exp T_DIV double_exp 
          | T_LEFTP double_exp T_RIGHTP 
          ;

comp_exp: int_exp T_LT int_exp 
        | int_exp T_GT int_exp 
        | int_exp T_LE int_exp 
        | int_exp T_GE int_exp 
        | int_exp T_EQEQ int_exp 
        | int_exp T_NEQ int_exp 
        | double_exp T_LT double_exp 
        | double_exp T_GT double_exp 
        | double_exp T_LE double_exp 
        | double_exp T_GE double_exp 
        | double_exp T_EQEQ double_exp 
        | double_exp T_NEQ double_exp 
        ;

bool_exp: T_TRUE 
        | T_FALSE 
        | comp_exp 
        | bool_exp T_AND bool_exp 
        | bool_exp T_OR bool_exp 
        | T_NOT bool_exp 
        | T_LEFTP bool_exp T_RIGHTP 
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