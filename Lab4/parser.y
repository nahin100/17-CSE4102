%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    void yyerror();
    #include "symtab.c"
	extern int lineno;
	extern int yylex();
%}

%union
{
    char str_val[100];
    int int_val;
}

%token INT IF ELSE WHILE CONTINUE BREAK PRINT DOUBLE CHAR 
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN FCONST ICONST CCONST
%token<str_val> ID

%type<int_val> type constant exp

%left ADDOP SUBOP
%right ASSIGN

%start code

%%
code: statements;

statements: statements statement | ;

statement: declaration | while_statement | if_statement ;

declaration: type ID SEMI 
            {
                printf("%d\n", $1);
                printf("%s\n", $2);
                insert($2, $1);
            }
            |type ID ASSIGN exp SEMI
            {
                printf("%d\n", $1);
                printf("%s\n", $2);
                insert($2, $1);

                typecheck(id_check($2), $4);
            }
            ;

type: INT {$$ = INT_TYPE;}
    | DOUBLE {$$ = REAL_TYPE;}
    | CHAR {$$ = CHAR_TYPE;}
    ;

exp: ID
    {
        $$ = id_check($1);    
    }
    |constant
    {
        $$ = $1;
    }
    |exp ADDOP exp
    {
        printf("exp1 = %d\n", $1);
        printf("exp2 = %d\n", $3);

        $$ = typecheck($1, $3);
    }
    |exp SUBOP exp
    ;

constant: ICONST {$$ = INT_TYPE;}
        | FCONST {$$ = REAL_TYPE;}
        | CCONST {$$ = CHAR_TYPE;}
        ;

while_statement: WHILE LPAREN exp RPAREN tail
                ;

if_statement: IF LPAREN exp RPAREN tail optional_else
                ;

tail: LBRACE statements RBRACE
    {
        printf("LBRACE statements RBRACE\n");
    }
    ;

optional_else: ELSE tail | ;
%%

void yyerror ()
{
	printf("Syntax error at line %d\n", lineno);
	exit(1);
}

int main (int argc, char *argv[])
{
	yyparse();
	printf("Parsing finished!\n");	
	return 0;
}
