%{
#include<stdio.h>
void yyerror(char *s);
int yylex();
%}

%token NUM ADD
%start cal

%%
cal: NUM ADD NUM {$$ = $1 + $3; printf("%d\n", $$);}
    ;
%%

int main()
{
  yyparse();
  printf("Parsing Finished");
  return 0;
}

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}