%{
#include<stdio.h>
void yyerror(char *s);
int yylex();
%}

%token INT_NUM FLOAT_NUM ADD SUB MUL DIV ID INT_TYPE FLOAT_TYPE ASSIGN SEMI IF LP RP LB RB
%start statements

%%
statements: statements statement {printf("statements statement\n");}
            |
            ;

statement: declaration {printf("declaration\n");}
            | if_statement {printf("if_statement\n");}
            ;

declaration: INT_TYPE ID ASSIGN INT_NUM SEMI {printf("INT_TYPE ID ASSIGN NUM SEMI\n");}
            ;

if_statement: IF LP exp RP if_extra {printf("IF LP exp RP if_extra\n");}
            ;

if_extra: SEMI {printf("SEMI\n");}
        | LB statements RB {printf("LB statements RB\n");}
        ;

exp: ID {printf("ID\n");}
%%

int main()
{
    yyparse();
    printf("Parsing Finished\n");
}

void yyerror(char *s)
{
    fprintf(stderr, "error: %s", s);
}