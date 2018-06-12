#include "tab_asm.h"

void initialiserTab(Tab_asm *tableau){
	(*tableau).nbElementTab = 0;
}

void addElement(Tab_asm *tableau, char instruction[LONGUEUR_STRING], int arg0, int arg1, int arg2){
	ElementTab elem;
	strcpy(elem.instruction,instruction);
	elem.arg0 = arg0;
	elem.arg1 = arg1;
	elem.arg2 = arg2;
	(*tableau).tab[(*tableau).nbElementTab]=elem;
	(*tableau).nbElementTab++;
}

void printTab(Tab_asm tableau){
	int i;
	for(i = 0; i<tableau.nbElementTab; i++){
		printf("instruction : %s\t%d\t%d\t%d\n",tableau.tab[i].instruction, tableau.tab[i].arg0, tableau.tab[i].arg1, tableau.tab[i].arg2);
	}
}
	
void writeTab(char* path,Tab_asm tableau){
    FILE* fichier = NULL;
	char* chaine;
    fichier = fopen(path, "w");

    if (fichier != NULL){
		int i;
		for(i = 0; i<tableau.nbElementTab; i++){
			fprintf(fichier,"%s\t%d\t%d\t%d\n",tableau.tab[i].instruction, tableau.tab[i].arg0, tableau.tab[i].arg1, tableau.tab[i].arg2);
		}
		fclose(fichier);
    } else {
        printf("Impossible d'ouvrir le fichier %s",path);
    }
}

void patch(Tab_asm *tableau, int index, int arg){
	(*tableau).tab[index].arg0 = arg;
}

