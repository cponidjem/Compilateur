#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TAILLE 500
#define LONGUEUR_STRING 80

typedef struct ElementTab{
	char instruction[LONGUEUR_STRING];
	int arg0;
	int arg1;
	int arg2;
} ElementTab;

typedef struct Tab_asm{
	ElementTab tab[TAILLE];
	int nbElementTab;
}Tab_asm;

void initialiserTab(Tab_asm *tableau);
void addElement(Tab_asm *tableau, char instruction[LONGUEUR_STRING], int arg0, int arg1, int arg2);
void printTab(Tab_asm tableau);
void writeTab(char* path, Tab_asm tableau);
void patch(Tab_asm *tableau, int index, int arg);
