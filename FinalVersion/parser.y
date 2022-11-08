%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int lineno;
	extern int yylex();
%}

%union
{
    char str_val[100];
    int int_val;
}

%token IF ELSE WHILE PRINT SCAN
%token ADDOP SUBOP MULOP DIVOP EQUOP LT GT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN
%token<str_val> ID
%token<int_val> ICONST INT

%left LT GT /*LT GT has lowest precedence*/
%left ADDOP 
%left MULOP /*MULOP has lowest precedence*/

%type<int_val> exp 

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);} ;

code: statements;

statements: statements statement | ;

statement:  declaration
           | assignment
           | if_statement
            ;

declaration: INT ID SEMI
            {
                insert($2, $1);
            }
            | INT ID ASSIGN ICONST SEMI
            {
                insert($2, $1);
                gen_code(LD_INT_VALUE, $4);
                int address = id_check($2);
                gen_code(ST, address);
            }
            | INT ID ASSIGN exp SEMI
            {
                insert($2, $1);
                int address = id_check($2);
                gen_code(STS, address);
            }
            ;

assignment: ID ASSIGN exp SEMI
		   {
			   int address = id_check($1);
			  
			  if(address!=-1)
				  gen_code(ST, address);
			  else 
			  {
				printf("Problem\n");
			  	exit(1);
			  }
		   }
		   | PRINT LPAREN ID RPAREN SEMI
			{
				int address = id_check($3);
				printf("%d\n", address);
				
				if(address!=-1)
					gen_code(WRITE_INT, address);
				else
				{
					printf("Problem\n");
					exit(1);
				}
			}
			| SCAN LPAREN ID RPAREN SEMI
			{
				int address = id_check($3);
				printf("%d\n", address);
				
				if(address!=-1)
					gen_code(SCAN_INT, address);
				else
				{
					printf("Problem\n");
					exit(1);
				}
			}
		   ;

exp: ID  
    {
        int address = id_check($1);
            
            if(address!=-1)
                gen_code(LD_VAR, address);
            else 
            {
            printf("Problem\n");
            exit(1);
            }
    }
    | ICONST { gen_code(LD_INT, $1); }
    | exp ADDOP exp { gen_code(ADD, -1); }
    | exp MULOP exp
    | exp GT exp
    | exp LT exp
    ;

if_statement: IF LPAREN exp RPAREN LBRACE statements RBRACE optional_else
        ;

optional_else: ELSE IF LPAREN exp RPAREN LBRACE statements RBRACE 
              | ELSE LBRACE statements RBRACE 
              | 
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

    printf("\n\n================STACK MACHINE INSTRUCTIONS================\n");
	print_code();

	printf("\n\n================x86 Assembly================\n");
	print_assembly();
	return 0;
}
