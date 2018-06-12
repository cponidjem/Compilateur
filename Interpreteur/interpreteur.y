%{
	#include <stdio.h>
	#include "../Compiler/tab_asm.h"
	int yylex(void);
	void yyerror(char*);
	Tab_asm tab;
	int registre[2];
	int memoire[1024];
%}

%union {char str[80]; int nb;}

%token t_INSTRUCT t_ARG
%type <nb> t_ARG
%type <str> t_INSTRUCT

%%
	
	S : S t_INSTRUCT t_ARG t_ARG t_ARG
		{
			addElement(&tab, $2, $3, $4, $5);
		};
	S : t_INSTRUCT t_ARG t_ARG t_ARG
		{
			addElement(&tab, $1, $2, $3, $4);
		};
	
%%

int main() {
	initialiserTab(&tab);
	yyparse();
	FILE* fichier = NULL;
	char* chaine;
    fichier = fopen("hexa_asm.hex", "w");
	int i;
    if (fichier != NULL){
		for (i = 0; i < tab.nbElementTab; i++) {
			if(strcmp(tab.tab[i].instruction,"ADD")==0){
				fprintf(fichier,"01%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);
				registre[tab.tab[i].arg0] = registre[tab.tab[i].arg1] + registre[tab.tab[i].arg2];
			} else if (strcmp(tab.tab[i].instruction,"SOU")==0) {
				fprintf(fichier,"03%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);
				registre[tab.tab[i].arg0] = registre[tab.tab[i].arg1] - registre[tab.tab[i].arg2];
			} else if (strcmp(tab.tab[i].instruction,"MUL")==0) {
				fprintf(fichier,"02%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);				
				registre[tab.tab[i].arg0] = registre[tab.tab[i].arg1] * registre[tab.tab[i].arg2];
			} else if (strcmp(tab.tab[i].instruction,"DIV")==0) {
				fprintf(fichier,"04%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);
				registre[tab.tab[i].arg0] = registre[tab.tab[i].arg1] / registre[tab.tab[i].arg2];
			} else if (strcmp(tab.tab[i].instruction,"AFC")==0) {
				fprintf(fichier,"06%02x%04x\n",tab.tab[i].arg0,tab.tab[i].arg1);
				registre[tab.tab[i].arg0] = tab.tab[i].arg1;
			} else if (strcmp(tab.tab[i].instruction,"LOAD")==0) {
				fprintf(fichier,"07%02x%04x\n",tab.tab[i].arg0,tab.tab[i].arg1);
				registre[tab.tab[i].arg0] = memoire[tab.tab[i].arg1];
			} else if (strcmp(tab.tab[i].instruction,"STORE")==0) {
				fprintf(fichier,"08%04x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1);
				memoire[tab.tab[i].arg0] = registre[tab.tab[i].arg1];
			} else if (strcmp(tab.tab[i].instruction,"EQU")==0) {
				fprintf(fichier,"09%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);
				if(registre[tab.tab[i].arg1] == registre[tab.tab[i].arg2]){
					registre[tab.tab[i].arg0] = 1;
				}else{
					registre[tab.tab[i].arg0] = 0;
				}
			} else if (strcmp(tab.tab[i].instruction,"INFE")==0) {
				fprintf(fichier,"0B%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);
				if(registre[tab.tab[i].arg1] <= registre[tab.tab[i].arg2]){
					registre[tab.tab[i].arg0] = 1;
				}else{
					registre[tab.tab[i].arg0] = 0;
				}
			} else if (strcmp(tab.tab[i].instruction,"SUPE")==0) {
				fprintf(fichier,"0D%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);
				if(registre[tab.tab[i].arg1] >= registre[tab.tab[i].arg2]){
					registre[tab.tab[i].arg0] = 1;
				}else{
					registre[tab.tab[i].arg0] = 0;
				}
			} else if (strcmp(tab.tab[i].instruction,"INF")==0) {
				fprintf(fichier,"0A%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);
				if(registre[tab.tab[i].arg1] < registre[tab.tab[i].arg2]){
					registre[tab.tab[i].arg0] = 1;
				}else{
					registre[tab.tab[i].arg0] = 0;
				}
			} else if (strcmp(tab.tab[i].instruction,"SUP")==0) {
				fprintf(fichier,"0C%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);
				if(registre[tab.tab[i].arg1] > registre[tab.tab[i].arg2]){
					registre[tab.tab[i].arg0] = 1;
				}else{
					registre[tab.tab[i].arg0] = 0;
				}
			} else if (strcmp(tab.tab[i].instruction,"JMPC")==0) {
				fprintf(fichier,"0F%04x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1);
				if(registre[tab.tab[i].arg1] == 0){
					//i = tab.tab[i].arg0 - 1;
				}
			} else if (strcmp(tab.tab[i].instruction,"JMP")==0) {
				fprintf(fichier,"0E%04x00\n",tab.tab[i].arg0);
				//i = tab.tab[i].arg0 - 1;
			} else if (strcmp(tab.tab[i].instruction,"AND")==0) {
				fprintf(fichier,"10%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);
				registre[tab.tab[i].arg0] = registre[tab.tab[i].arg1] & registre[tab.tab[i].arg2];
			} else if (strcmp(tab.tab[i].instruction,"OR")==0) {
				fprintf(fichier,"11%02x%02x%02x\n",tab.tab[i].arg0,tab.tab[i].arg1,tab.tab[i].arg2);
				registre[tab.tab[i].arg0] = registre[tab.tab[i].arg1] | registre[tab.tab[i].arg2];
			}

		}
		fclose(fichier);
    } else {
        printf("Impossible d'ouvrir le fichier hexa_asm.hex");
    }
	
	for (i = 0; i<100; i++){
		printf("%d \t",memoire[i]);
	}
	
}
