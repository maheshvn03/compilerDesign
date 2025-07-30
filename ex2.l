%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100

char* symbol_table[MAX_SYMBOLS];
int symbol_count = 0;

// Check if identifier already exists
int exists_in_table(char* id) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i], id) == 0)
            return 1;
    }
    return 0;
}

// Add identifier to symbol table
void add_to_table(char* id) {
    if (!exists_in_table(id)) {
        symbol_table[symbol_count++] = strdup(id);
    }
}
%}

%%

// Keywords
"int"|"float"|"char"|"double"|"if"|"else"|"for"|"while"|"return"  { printf("Keyword: %s\n", yytext); }

// Identifiers
[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Identifier: %s\n", yytext);
    add_to_table(yytext);
}

// Constants (integers and floats)
[0-9]+\.[0-9]+|[0-9]+   { printf("Constant: %s\n", yytext); }

// Operators
"=="|"!="|"<="|">="|"="|"+"|"-"|"*"|"/"|"%"|"++"|"--" {
    printf("Operator: %s\n", yytext);
}

// Single-line comment
"//".*                { printf("Single-line Comment: %s\n", yytext); }

// Multi-line comment
"/*"([^*]|\*+[^*/])*\*+\/   { printf("Multi-line Comment\n"); }

// Whitespace
[ \t\n]+              { /* ignore whitespace */ }

// Anything else
.                     { printf("Unknown token: %s\n", yytext); }

%%

// Main function
int main() {
    printf("Lexical Analyzer Output:\n\n");
    yylex();

    printf("\nSymbol Table:\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("%d: %s\n", i + 1, symbol_table[i]);
    }

    return 0;
}

int yywrap() {
    return 1;
}
