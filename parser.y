%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include "tree.h"
    
    void yyerror(const char* s);
    //int yylex();

    struct TreeNode* root = NULL;
%}

%union {
    int int_value;
    double double_value;
    char* ident;
    int bool_value;
    struct TreeNode* tree_node;
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

%type <tree_node> program declarations declaration type statements statement assignment if_exp else_if optional_else for_exp while_exp tail increment expression int_exp double_exp bool_exp comp_op

%start program

%%
program: T_LET T_LEFTS declarations T_RIGHTS T_IN statements T_END {
            $$ = create_node("program");
            add_child($$, create_node("LET"));
            add_child($$, $3);
            add_child($$, create_node("IN"));
            add_child($$, $6);
            add_child($$, create_node("END"));
            root = $$;
        }
;

/*declarations*/
declarations: declarations declaration {
                 $$ = $1;
                 add_child($$, $2);
             }
           | declaration {
                 $$ = create_node("declarations");
                 add_child($$, $1);
             }
            ;

declaration: type T_ID T_SC {
                $$ = create_node("declaration");
                add_child($$, $1);
                add_child($$, create_node("ID"));
            }
           ;

type: INT {
           $$ = create_node("INT");
       }
    | STRING {
           $$ = create_node("STRING");
       }
    | DOUBLE {
           $$ = create_node("DOUBLE");
       }
    | BOOL {
           $$ = create_node("BOOL");
       }
    ;

/*statements*/
statements: statements statement {
                $$ = $1;
                add_child($$, $2);
            }
          | statement {
                $$ = create_node("statements");
                add_child($$, $1);
            }
          ;

statement: expression T_SC {
               $$ = $1;
           }
         | if_exp {
               $$ = $1;
           }
         | for_exp {
               $$ = $1;
           }
         | while_exp {
               $$ = $1;
           }
         | assignment T_SC {
               $$ = $1;
           }
         ;

assignment: T_ID T_EQ expression {
                $$ = create_node("assignment");
                add_child($$, create_node("ID"));
                add_child($$, $3);
            }
          ;

if_exp: T_IF T_LEFTP bool_exp T_RIGHTP tail optional_else {
           $$ = create_node("if");
           add_child($$, $3);
           add_child($$, $5);
           if ($6) add_child($$, $6);
       }
      | T_IF T_LEFTP bool_exp T_RIGHTP tail else_if optional_else {
           $$ = create_node("if-else_if");
           add_child($$, $3);
           add_child($$, $5);
           add_child($$, $6);
           if ($7) add_child($$, $7);
       }
      ;

else_if: else_if T_ELSE T_IF T_LEFTP bool_exp T_RIGHTP tail {
            $$ = $1;
            TreeNode* elif = create_node("else_if");
            add_child(elif, $5);
            add_child(elif, $7);
            add_child($$, elif);
        }
       | T_ELSE T_IF T_LEFTP bool_exp T_RIGHTP tail {
            $$ = create_node("else_if");
            add_child($$, $4);
            add_child($$, $6);
        }
       ;

optional_else: T_ELSE tail {
                  $$ = $2;
              }
             | /* empty */ {
                  $$ = NULL;
              }
             ;

for_exp: T_FOR T_LEFTP assignment T_SC bool_exp T_SC increment T_RIGHTP tail {
            $$ = create_node("for");
            add_child($$, $3);
            add_child($$, $5);
            add_child($$, $7);
            add_child($$, $9);
        }
       ;

while_exp: T_WHILE T_LEFTP bool_exp T_RIGHTP tail {
              $$ = create_node("while");
              add_child($$, $3);
              add_child($$, $5);
          }
         ;

tail: T_LEFTC statements T_RIGHTC {
         $$ = $2;
     }
    ;

increment: T_ID T_PLUS T_PLUS {
               $$ = create_node("increment");
               add_child($$, create_node("ID"));
           }
         ;

/*expressions*/
expression: T_ID {
                $$ = create_node("expression");
               add_child($$, create_node("ID"));
            } 
          |int_exp {
                $$ = $1;
            }
          | double_exp {
                $$ = $1;
            }
          | bool_exp {
                $$ = $1;
            }
          ;

int_exp: T_INT {
             $$ = create_node("int_exp");
             char buffer[20];
             sprintf(buffer, "%d", $1);
             add_child($$, create_node(buffer));
         }
       | int_exp T_PLUS int_exp {
             $$ = create_node("int_exp");
             add_child($$, $1);
             add_child($$, create_node("PLUS"));
             add_child($$, $3);
         }
       | int_exp T_MINUS int_exp {
             $$ = create_node("int_exp");
             add_child($$, $1);
             add_child($$, create_node("MINUS"));
             add_child($$, $3);
         }
       | int_exp T_MULT int_exp {
             $$ = create_node("int_exp");
             add_child($$, $1);
             add_child($$, create_node("MULT"));
             add_child($$, $3);
         }
       | int_exp T_DIV int_exp {
             $$ = create_node("int_exp");
             add_child($$, $1);
             add_child($$, create_node("DIV"));
             add_child($$, $3);
         }
       | int_exp T_MOD int_exp {
             $$ = create_node("int_exp");
             add_child($$, $1);
             add_child($$, create_node("MOD"));
             add_child($$, $3);
         }
       | T_LEFTP int_exp T_RIGHTP {
             $$ = $2;
         }
       ;

double_exp: T_DOUBLE {
                $$ = create_node("double_exp");
                char buffer[40];
                sprintf(buffer, "%f", $1);
                add_child($$, create_node(buffer));
            }
          | double_exp T_PLUS double_exp {
                $$ = create_node("double_exp");
                add_child($$, $1);
                add_child($$, create_node("+"));
                add_child($$, $3);
            }
          | double_exp T_MINUS double_exp {
                $$ = create_node("double_exp");
                add_child($$, $1);
                add_child($$, create_node("-"));
                add_child($$, $3);
            }
          | double_exp T_MULT double_exp {
                $$ = create_node("double_exp");
                add_child($$, $1);
                add_child($$, create_node("*"));
                add_child($$, $3);
            }
          | double_exp T_DIV double_exp {
                $$ = create_node("double_exp");
                add_child($$, $1);
                add_child($$, create_node("/"));
                add_child($$, $3);
            }
          | T_LEFTP double_exp T_RIGHTP {
                $$ = $2;
            }
          ;

bool_exp: T_TRUE {
             $$ = create_node("bool_exp");
             add_child($$, create_node("true"));
         }
        | T_FALSE {
             $$ = create_node("bool_exp");
             add_child($$, create_node("false"));
         }
        | bool_exp T_AND bool_exp {
             $$ = create_node("bool_exp");
             add_child($$, $1);
             add_child($$, create_node("and"));
             add_child($$, $3);
         }
        | bool_exp T_OR bool_exp {
             $$ = create_node("bool_exp");
             add_child($$, $1);
             add_child($$, create_node("or"));
             add_child($$, $3);
         }
        | T_NOT bool_exp {
             $$ = create_node("bool_exp");
             add_child($$, create_node("not"));
             add_child($$, $2);
         }
        | T_LEFTP bool_exp T_RIGHTP {
             $$ = $2;
         }
        | int_exp comp_op int_exp {
             $$ = create_node("bool_exp");
             add_child($$, $1);
             add_child($$, $2);
             add_child($$, $3);
         } 
        | double_exp comp_op double_exp {
             $$ = create_node("bool_exp");
             add_child($$, $1);
             add_child($$, $2);
             add_child($$, $3);
         }
        ;

comp_op: T_LT {
            $$ = create_node("comp_op");
            add_child($$, create_node("<"));
        }
       | T_GT {
            $$ = create_node("comp_op");
            add_child($$, create_node(">"));
        }
       | T_LE {
            $$ = create_node("comp_op");
            add_child($$, create_node("<="));
        }
       | T_GE {
            $$ = create_node("comp_op");
            add_child($$, create_node(">="));
        }
       | T_EQEQ {
            $$ = create_node("comp_op");
            add_child($$, create_node("=="));
        }
       | T_NEQ {
            $$ = create_node("comp_op");
            add_child($$, create_node("!="));
        }
       ; 

%%

void yyerror(const char* s){
    printf("%s\n", s);
}

int main(){
    printf("aaaa");
    int res = yyparse();    
    printf("aaaa");
    printf("%d ", res);
    if(res == 0){
        printf("Ulaz je ispravan!\n");
        print_tree(root, 0);
    }
    else{
        printf("Ulaz nije ispravan!\n");
    }

    return 0;
}
