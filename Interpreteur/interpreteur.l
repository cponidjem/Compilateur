%{
	#include "interpreteur.tab.h"
%}
%%
[ \t\n]+ 					;
ADD 						{strcpy(yylval.str,yytext);return t_INSTRUCT;}
MUL							{strcpy(yylval.str,yytext);return t_INSTRUCT;}
SOU							{strcpy(yylval.str,yytext);return t_INSTRUCT;}
DIV							{strcpy(yylval.str,yytext);return t_INSTRUCT;}
STORE						{strcpy(yylval.str,yytext);return t_INSTRUCT;}
LOAD						{strcpy(yylval.str,yytext);return t_INSTRUCT;}
AFC							{strcpy(yylval.str,yytext);return t_INSTRUCT;}
JMPC						{strcpy(yylval.str,yytext);return t_INSTRUCT;}
JMP							{strcpy(yylval.str,yytext);return t_INSTRUCT;}
EQU							{strcpy(yylval.str,yytext);return t_INSTRUCT;}
INFE						{strcpy(yylval.str,yytext);return t_INSTRUCT;}
SUPE						{strcpy(yylval.str,yytext);return t_INSTRUCT;}
INF							{strcpy(yylval.str,yytext);return t_INSTRUCT;}
SUP							{strcpy(yylval.str,yytext);return t_INSTRUCT;}
AND							{strcpy(yylval.str,yytext);return t_INSTRUCT;}
OR							{strcpy(yylval.str,yytext);return t_INSTRUCT;}
[0-9]+						{yylval.nb = atoi(yytext);return t_ARG;}
-1							{yylval.nb = atoi(yytext);return t_ARG;}							
