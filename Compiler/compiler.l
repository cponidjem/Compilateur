%{
	#include "compiler.tab.h"
%}
nb							[0-9]+
%%
[ \t\n]+ 					;
, 							return t_VIRGULE;
; 							return t_FIN_INSTRUCT;
main 						return t_MAIN;
while						return t_WHILE;
if							return t_IF;
else						return t_ELSE;
printf 						return t_PRINTF;
return						return t_RETURN;
\( 							return t_PARENTHESE_OUV;
\)							return t_PARENTHESE_FERM;
\{ 							return t_ACCOLADE_OUV;
\} 							return t_ACCOLADE_FERM;
const 						return t_CONST;
int 						{strcpy(yylval.str,yytext);return t_TYPE;}
{nb} 						{yylval.nb = atoi(yytext);return t_ENTIER;}
-{nb}						{yylval.nb = atoi(yytext);return t_ENTIER;}
{nb}\^{nb}					{yylval.nb = atoi(yytext);return t_ENTIER;}
-{nb}\^{nb}					{yylval.nb = atoi(yytext);return t_ENTIER;}
{nb}\^-{nb}					{yylval.nb = atoi(yytext);return t_ENTIER;}
-{nb}\^-{nb}				{yylval.nb = atoi(yytext);return t_ENTIER;}
\+ 							return t_ADD;
- 							return t_SOUSTRACT;
\* 							return t_MULT;
\/ 							return t_DIV;
==							return t_EGALITE;
"<="						return t_INF_EGAL;
">="						return t_SUP_EGAL;
"<"							return t_INF;
">"							return t_SUP;
= 							return t_EGAL;
&&							return t_ET;
"||"						return t_OU;
[A-Za-z][A-Za-z0-9_]*		{strcpy(yylval.str,yytext);return t_NOM;}
