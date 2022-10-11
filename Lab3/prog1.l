%option noyywrap

%{
    #include "prog1.tab.h"
%}

digit [0-9]
number ({digit}+)
delim [ \t\n]
ws {delim}+

%%
{ws} {}
{number} {yylval = atoi(yytext); return(NUM);}
"+" {return(ADD);}
"-" {return(SUB);}
%%
