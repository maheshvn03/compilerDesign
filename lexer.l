%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX 100

// Symbol table structure
struct Symbol {
    char name[50];
} symtab[MAX];

int symCount = 0;

// Function to check if identifier exists
int search(char *name) {
    for (int i = 0; i < symCount; i++) {
        if (strcmp(symtab[i].name, name) == 0)
            return 1;
    }
    return 0;
}

// Add to symbol table
void addToSymbolTable(char *name) {
    if (!search(name)) {
        strcpy(symtab[symCount].name, name);
        symCount++;
    }
}

// List of C keywords
char *keywords[] = {
    "int", "float", "char", "double", "return",
    "if", "else", "while", "for", "void", "main", "include"
};

int isKeyword(char *word) {
    for (int i = 0; i < sizeof(keywords) / sizeof(keywords[0]); i++) {
        if (strcmp(word, keywords[i]) == 0)
            return 1;
    }
    return 0;
}
%}

%%
"//".*                        { printf("Single-line comment: %s\n", yytext); }
"/*"([^*]|\*+[^*/])*\*+"/"    { printf("Multi-line comment\n"); }

[ \t\n]+                    ; // Ignore whitespace

"=="|"!="|"<="|">="|"<"|">"  { printf("Relational operator: %s\n", yytext); }
"+"|"-"|"*"|"/"|"="          { printf("Operator: %s\n", yytext); }

[0-9]+                      { printf("Integer constant: %s\n", yytext); }
[0-9]+\.[0-9]+              { printf("Float constant: %s\n", yytext); }

[a-zA-Z_][a-zA-Z0-9_]*      {
                              if (isKeyword(yytext))
                                  printf("Keyword: %s\n", yytext);
                              else {
                                  printf("Identifier: %s\n", yytext);
                                  addToSymbolTable(yytext);
                              }
                            }

.                           { printf("Unknown character: %s\n", yytext); }
%%

int main(int argc, char **argv) {
    printf("Lexical Analysis Start:\n\n");
    yylex();

    printf("\nSymbol Table:\n");
    for (int i = 0; i < symCount; i++) {
        printf("%d: %s\n", i + 1, symtab[i].name);
    }
    return 0;
}

int yywrap() {
    return 1;
}
