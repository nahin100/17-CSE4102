%option noyywrap

%{
//Roll Number: 1703xxx
//
%}

digit [0-9]
delim [ \t]

%%
{digit}{digit}* {printf("%s -> NUMBER\n", yytext);}
"+" {printf("%s -> ADD\n", yytext);}
{delim} {}
%%

int main()
{
  yylex();
  return 0;
}
