%{
#include<stdio.h>
void yyerror(char *s);
int yylex();
%}

%token NUM ADD SUB
%start exp

%%
exp: exp ADD NUM {$$=$1+$3; printf("NUM ADD NUM %d+%d=%d\n", $1, $3, $$);}
    |exp SUB NUM {$$=$1-$3; printf("NUM SUB NUM %d-%d=%d\n", $1, $3, $$);}
    |NUM {$$=$1; printf("%d=%d\n", $$, $1);}
    ;
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