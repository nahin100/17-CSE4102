%option noyywrap

%{
    #include "prog4.tab.h"
%}

digit [0-9]
number ({digit}+)
delim [ \t\n]
ws {delim}+
alpha [A-Za-z]
undr [_]

%%
{ws} {}
{number}"."{number} {return(FLOAT_NUM);}
{number} {return(INT_NUM);}
"int" {return(INT_TYPE);}
"float" {return(FLOAT_TYPE);}
"if" {return(IF);}
"+" {return(ADD);}
"-" {return(SUB);}
"*" {return(MUL);}
"/" {return(DIV);}
"=" {return(ASSIGN);}
";" {return(SEMI);}
"(" {return(LP);}
")" {return(RP);}
"{" {return(LB);}
"}" {return(RB);}
({undr}|{alpha})({undr}|{alpha}|{digit})* {return (ID);}

%%
