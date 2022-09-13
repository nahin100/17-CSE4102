%option noyywrap

%{

%}

letter [a-zA-Z]
digit [0-9]
delim [ \t]
under [_]
num {digit}{digit}*
float_num {num}*[.]{num}
%%
{num} {printf("%s -> NUMBER\n", yytext);}
"+" {printf("%s -> ADD\n", yytext);}
"int" {printf("%s -> INT\n", yytext);}
"float" {printf("%s -> FLOAT\n", yytext);}
"while" {printf("%s -> WHILE\n", yytext);}
"(" {printf("%s -> LP\n", yytext);}
")" {printf("%s -> RP\n", yytext);}
"{" {printf("%s -> LB\n", yytext);}
"}" {printf("%s -> RB\n", yytext);}
"=" {printf("%s -> ASSIGN\n", yytext);}
";" {printf("%s -> SEMI\n", yytext);}
({under}|{letter})({under}|{letter}|{digit})* {printf("%s -> ID\n", yytext);}
{float_num} {printf("%s -> FLOAT_NUM\n", yytext);}
{delim} {}
%%

int main()
{
  yylex();
  return 0;
}
