%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tempVar = 1;
char tac[100][100];
int tacIndex = 0;

char* createTemp() {
    char* temp = (char*) malloc(10);
    sprintf(temp, "t%d", tempVar++);
    return temp;
}
%}

%union {
    char* str;
}

%token <str> ID NUM
%token PLUS MUL ASSIGN SEMI

%type <str> expr term factor

%%

stmt: ID ASSIGN expr SEMI {
            printf("TAC:\n");
            printf("%s = %s\n", $1, $3);
            for (int i = 0; i < tacIndex; i++) {
                printf("%s\n", tac[i]);
            }
      }
    ;

expr: expr PLUS term {
            char* temp = createTemp();
            sprintf(tac[tacIndex++], "%s = %s + %s", temp, $1, $3);
            $$ = temp;
      }
    | term { $$ = $1; }
    ;

term: term MUL factor {
            char* temp = createTemp();
            sprintf(tac[tacIndex++], "%s = %s * %s", temp, $1, $3);
            $$ = temp;
      }
    | factor { $$ = $1; }
    ;

factor: ID { $$ = $1; }
      | NUM { $$ = $1; }
      ;

%%

int main() {
    yyparse();
    return 0;
}

int yyerror(char* s) {
    printf("Error: %s\n", s);
    return 0;
}
