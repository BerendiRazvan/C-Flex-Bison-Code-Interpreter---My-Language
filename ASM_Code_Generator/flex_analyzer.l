/* analizor pentru un MLP din C */

%{
   /* definitii accesibile in yylex si main */
  #include "bison_analyzer.tab.h"
  #include <stdio.h>
  #include <string.h>

  int liniaCurenta = 1;
%}

%option noyywrap
  /* reguli */
ID       [a-zA-Z_]+[a-zA-Z_0-9]*
CONST    [-+]{0,1}(0|[1-9]{0,1}[0-9]*){0,1}
%%

"#include" { return INCLUDE; }
"<iostream>" { return IOSTREAM; }
"using" { return USING; }
"namespace" { return NAMESPACE; }
"std" { return STD; }
"int" { return INT; }
"main()" { return MAIN; }
"cin" { return CIN; }
"cout" { return COUT; }
"return" { return RETURN; }
"+"  { memset(yylval.sval, 0, sizeof(yylval.sval)); strncpy(yylval.sval, yytext, strlen(yytext)); return SEMN; }
"-"  { memset(yylval.sval, 0, sizeof(yylval.sval)); strncpy(yylval.sval, yytext, strlen(yytext)); return SEMN; }
"*"  { memset(yylval.sval, 0, sizeof(yylval.sval)); strncpy(yylval.sval, yytext, strlen(yytext)); return SEMN; }
"/"  { memset(yylval.sval, 0, sizeof(yylval.sval)); strncpy(yylval.sval, yytext, strlen(yytext)); return SEMN; }
"="  { return EQUAL; }
";"  { return SEMICOLON; }
"{"  { return BRACEL; }
"}"  { return BRACER; }
","  { return COMMA; }
">>"  { return INOP; }
"<<"  { return OUTOP; }


{ID} { memset(yylval.sval, 0, sizeof(yylval.sval)); strncpy(yylval.sval, yytext, strlen(yytext)); return ID; }
{CONST}  { memset(yylval.sval, 0, sizeof(yylval.sval)); strncpy(yylval.sval, yytext, strlen(yytext)); return CONST; }

[ \t]  /* whitespace */
[\n]  { liniaCurenta++; }
.  { printf("%s unknown token on line %d!!\n", yytext, liniaCurenta); return -1; }

%%




