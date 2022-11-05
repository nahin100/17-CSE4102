%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "parser.tab.h"
	
	int lineno = 1; // initialize to 1
	void yyerror();
%}

alpha     [a-zA-Z]
digit     [0-9]
alnum     {alpha}|{digit}
print     [ -~]

ID        {alpha}{alnum}*
ICONST    [0-9]{digit}*
FCONST    {digit}*"."{digit}+
CCONST    (\'{print}\')
STRING    \"{print}*\"
%%

"//".*     { } 

"int"      { return INT; }
"double"   { return DOUBLE; }
"char"	   { return CHAR; }

"if"	   {return IF;}
"else"	   {return ELSE;}
"while"    { return WHILE; }
"for"      { return FOR; }
"continue" { return CONTINUE; }
"break"    { return BREAK; }
"void"     { return VOID; }
"return"   { return RETURN; }

"+"        { return ADDOP; }
"-"        { return SUBOP; }
"*"        { return MULOP; }
"/"        { return DIVOP; }
"++"       { return INCR; }
"--"       { return DECR; }
"||"       { return OROP; }
"&&"       { return ANDOP; }
"!"        { return NOTOP; }
"=="       { return EQUOP; }
"!="       { return NEQUOP; }
">="       { return GTEQ; }
">"        { return GT; }
"<="       { return LTEQ; }
"<"        { return LT; }

"("        { return LPAREN; }
")"        { return RPAREN; }
"{"        { return LBRACE; }
"}"        { return RBRACE; }
";"        { return SEMI; }
","        { return COMMA; }
"="        { return ASSIGN; }

{ID}        {return ID;}
{ICONST}    {return ICONST;}
{FCONST}    {return FCONST;}
{CCONST}    {return CCONST;}
{STRING}    {return STRING;}

"\n"        { lineno += 1; }
[ \t\r\f]+  

.           { yyerror("Unrecognized character"); }
