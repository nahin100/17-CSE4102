%option noyywrap

%{
//Roll Number: 1703xxx
//
#include "cal2.tab.h"
%}

digit [0-9]
delim [ \t]

%%
{digit}{digit}* { yylval = atoi(yytext); return(NUM);}
"+" {return(ADD);}
{delim} {}
%%

