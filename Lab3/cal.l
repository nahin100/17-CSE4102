%option noyywrap

%{
    #include "cal.tab.h"
%}

digit [0-9]
number ({digit}+)
delim [ \t\n]
ws {delim}+
alpha [A-Za-z]
undr [_]

%%
{ws} {}
{number} {yylval = atoi(yytext); return(NUM);}
"+" {return(ADD);}
"-" {return(SUB);}
"*" {return(MUL);}
"/" {return(DIV);}
%%
