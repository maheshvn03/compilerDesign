%{
#include "y.tab.h"
#include <string.h>
%}

%%

[ \t\n]            ; // Ignore whitespace
[a-zA-Z][a-zA-Z0-9]*  { yylval.str = strdup(yytext); return ID; }
[0-9]+            { yylval.str = strdup(yytext); return NUM; }

"+"               { return PLUS; }
"*"               { return MUL; }
"="               { return ASSIGN; }
";"               { return SEMI; }

.                 ; // Ignore other chars

%%

int yywrap() { return 1; }
