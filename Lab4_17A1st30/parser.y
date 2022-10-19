%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	void yyerror();
	extern int lineno;
	extern int yylex();
%}

%token INT IF ELSE WHILE CONTINUE BREAK PRINT DOUBLE CHAR
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN
%token ID
%token ICONST
%token FCONST
%token CCONST

%start code

%%
code: statements;

statements: statements statement | ;

statement:  declaration
            ;

declaration: type ID SEMI
            |type ID ASSIGN exp SEMI
            ;

type: INT 
    | DOUBLE 
    | CHAR
    ;

exp: constant
    | ID
    ;

constant: ICONST
        | FCONST
        | CCONST
        ;
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
