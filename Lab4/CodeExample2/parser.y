%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	void yyerror();
	extern int lineno;
	extern int yylex();
%}

%union
{
    char str_val[100];
    int int_val;
}

%token CHAR INT DOUBLE IF ELSE WHILE FOR CONTINUE BREAK VOID RETURN
%token ADDOP SUBOP MULOP DIVOP INCR DECR OROP ANDOP NOTOP EQUOP NEQUOP GTEQ GT LTEQ LT
%token LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN COMMA
%token ID
%token ICONST
%token FCONST
%token CCONST
%token STRING

%right ASSIGN /*ASSIGN has lowest precedence*/
%left OROP
%left ANDOP
%left EQUOP NEQUOP
%left GTEQ GT LTEQ LT
%left ADDOP SUBOP
%left MULOP DIVOP
%right NOTOP INCR DECR
%left LPAREN RPAREN /*LPAREN has highest precedence*/

%start code

%%
code: statements_optional functions;

statements_optional: statements_optional statement | /* empty */ ;

// /* declarations */
declarations_optional: declarations_optional declaration | /* empty */ ;

declaration: type names SEMI ;

type: INT | CHAR | DOUBLE | VOID ;

names: names COMMA ID | names COMMA init | ID | init ;

init: ID ASSIGN constant;

/* statements */
statement:
	declarations_optional |
    if_statement | for_statement | while_statement | assigment SEMI |
	CONTINUE SEMI | BREAK SEMI | function_call SEMI | ID INCR SEMI | INCR ID SEMI |
    ID DECR SEMI | DECR ID SEMI | RETURN exp SEMI
    ;

if_statement:
	IF LPAREN exp RPAREN tail else_if optional_else |
	IF LPAREN exp RPAREN tail optional_else
    ;

else_if: 
	else_if ELSE IF LPAREN exp RPAREN tail |
	ELSE IF LPAREN exp RPAREN tail
    ;

optional_else: ELSE tail | /* empty */ ;

for_statement: FOR LPAREN assigment SEMI exp SEMI exp RPAREN tail ;

while_statement: WHILE LPAREN exp RPAREN tail ;

tail: LBRACE statements_optional RBRACE ;

exp:
    exp ADDOP exp |
    exp SUBOP exp |
    exp MULOP exp |
    exp DIVOP exp |
    INCR ID |
    ID INCR |
    DECR ID |
    ID DECR |
    exp OROP exp |
    exp ANDOP exp |
    NOTOP exp |
    exp EQUOP exp |
    exp NEQUOP exp |
    exp GTEQ exp |
    exp GT exp |
    exp LTEQ exp |
    exp LT exp |
    LPAREN exp RPAREN |
    ID |
    sign constant |
    function_call
    ;

sign: ADDOP | /* empty */ ; 

constant: ICONST | FCONST | CCONST ;

assigment: ID ASSIGN exp ; 

function_call: ID LPAREN call_params RPAREN;

call_params: call_params call_param | /* empty */;

call_param: call_param COMMA exp | call_param COMMA STRING | STRING | exp;

/* functions */
functions: functions function | function ;

function: function_head function_tail ;
		
function_head: return_type ID LPAREN parameters_optional RPAREN ;

return_type: type;

parameters_optional: parameters | /* empty */ ;

parameters: parameters COMMA parameter | parameter ;

parameter : type ID ;

function_tail: LBRACE statements_optional RBRACE ;

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
