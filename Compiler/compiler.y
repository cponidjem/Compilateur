%{
	#include "pile.h"
	#include "tab_asm.h"
	#include <stdio.h> 
	int yylex(void);
	void yyerror(char*);
	Pile *pile;
	int profondeur;
	char type[LONGUEUR];
	Tab_asm tab;
%}

%union {char str[80]; int nb;}

%token t_VIRGULE t_FIN_INSTRUCT t_MAIN t_PRINTF t_RETURN t_PARENTHESE_OUV t_PARENTHESE_FERM t_ACCOLADE_OUV t_ACCOLADE_FERM t_CONST t_TYPE t_ADD t_SOUSTRACT t_MULT t_DIV t_EGAL t_ENTIER t_NOM t_WHILE t_IF t_ELSE t_ET t_OU t_EGALITE t_INF_EGAL t_SUP_EGAL t_INF t_SUP
%left t_ADD t_SOUSTRACT t_OU
%left t_MULT t_DIV t_ET
%left t_PARENTHESE_OUV

%type <str> t_NOM t_TYPE
%type <nb> t_ENTIER t_IF t_WHILE t_PARENTHESE_OUV

%%
S : Main ;

Params : t_PARENTHESE_OUV ParamNext t_PARENTHESE_FERM | t_PARENTHESE_OUV t_PARENTHESE_FERM;
ParamNext : ParamNext t_VIRGULE Param | Param;
Param : t_TYPE t_NOM;

Corps : t_ACCOLADE_OUV Instructions t_ACCOLADE_FERM
			{
				profondeur++;
			};

Main : t_TYPE t_MAIN Params CorpsMain
			{
				printTab(tab);
			};

CorpsMain : t_ACCOLADE_OUV Declarations Instructions t_ACCOLADE_FERM
			{
				profondeur++;
			};

Declarations : Declarations Declaration t_FIN_INSTRUCT | ;
Declaration : t_TYPE 
			{
				strcpy(type,$1);
			}
			DeclarationMultiple;
Declaration : t_CONST t_TYPE 
			{
				strcpy(type,$2);
			}
			DeclarationMultiple;

DeclarationMultiple : DeclarationMultiple t_VIRGULE Variable | Variable;

Variable : t_NOM t_EGAL t_ENTIER
			{
				empiler(pile, $1, type, profondeur, 0);

				addElement(&tab,"AFC", 0, $3, -1);
				addElement(&tab,"STORE", getAdresse(pile,$1,profondeur), 0, -1);
			};
Variable : t_NOM
			{
				empiler(pile, $1, type, profondeur, 0);	
			};

Instructions : Instruction t_FIN_INSTRUCT Instructions | StructureControle Instructions  |  ;
Instruction : AppelFonction | Affectation | Return;

Condition : t_PARENTHESE_OUV Condition t_PARENTHESE_FERM;
Condition : Condition t_ET Condition
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "AND", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);				
			};
Condition : Condition t_OU Condition
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "OR", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);				
			};
Condition : Expression t_EGALITE Expression
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "EQU", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);
			};
Condition : Expression t_INF_EGAL Expression
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "INFE", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);
			};
Condition : Expression t_SUP_EGAL Expression
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "SUPE", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);
			};
Condition : Expression t_INF Expression
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "INF", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);
			};
Condition : Expression t_SUP Expression
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "SUP", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);
			};

StructureControle : If | IfElse | While;

If : t_IF t_PARENTHESE_OUV Condition t_PARENTHESE_FERM
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "JMPC", -1, 0, -1);
				$1 = tab.nbElementTab - 1;
			} Corps
			{	
				addElement(&tab, "JMP", tab.nbElementTab+1, -1, -1);			
				patch(&tab,$1,tab.nbElementTab);
				$<nb>$ = tab.nbElementTab-1;
			};
IfElse : If t_ELSE Corps
			{
				patch(&tab,$<nb>1,tab.nbElementTab);
			};

While : t_WHILE t_PARENTHESE_OUV
			{
				$1 = tab.nbElementTab;
			}  Condition t_PARENTHESE_FERM
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "JMPC", -1, 0, -1);
				$2 = tab.nbElementTab - 1;
			} Corps
			{
				addElement(&tab, "JMP", $1, -1, -1);
				patch(&tab,$2,tab.nbElementTab);
			};

Return : t_RETURN Expression;

AppelFonction : t_PRINTF t_PARENTHESE_OUV t_NOM t_PARENTHESE_FERM;

Affectation : t_NOM t_EGAL Expression
			{
				int trouve = 0;
				int profondeurTest = profondeur;
				while(!trouve && profondeurTest >= 0){
					if(getAdresse(pile,$1,profondeurTest)!=-1){
						trouve = 1;
						addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
						depiler(pile);
						addElement(&tab, "STORE", getAdresse(pile,$1,profondeurTest), 0, -1);			
					}
					profondeurTest--;
				}
				if(!trouve){
					exit(EXIT_FAILURE);
				}
			};

Expression : t_PARENTHESE_OUV Expression t_PARENTHESE_FERM;
Expression : Expression t_ADD Expression
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "ADD", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);
			};

Expression : Expression t_SOUSTRACT Expression
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "SOU", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);
			};
Expression : Expression t_MULT Expression
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "MUL", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);
			};
Expression : Expression t_DIV Expression
			{
				addElement(&tab, "LOAD", 0, getDerniereAdresse(pile), -1);
				depiler(pile);
				addElement(&tab, "LOAD", 1, getDerniereAdresse(pile), -1);
				addElement(&tab, "DIV", 0, 1, 0);
				addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);
			};
Expression : t_ENTIER
			{
				empiler(pile, "temp", type, profondeur, 1);
				addElement(&tab,"AFC", 0, $1, -1);
				addElement(&tab,"STORE", getDerniereAdresse(pile), 0, -1);
			};
Expression : t_NOM
			{
				int trouve = 0;
				int profondeurTest = profondeur;
				while(!trouve && profondeurTest >= 0){
					if(getAdresse(pile,$1,profondeurTest)!=-1){
						trouve = 1;
						empiler(pile, "temp", type, profondeur, 1);
						addElement(&tab, "LOAD", 0, getAdresse(pile,$1,profondeurTest), -1);
						addElement(&tab, "STORE", getDerniereAdresse(pile), 0, -1);	
					} 
					profondeurTest--;
				}
				if(!trouve){
					exit(EXIT_FAILURE);
				}
			};


%%

int main() {
	pile = initialiser();
	initialiserTab(&tab);
	profondeur = 0;
	yyparse();
	writeTab("testTab.s", tab);
}
