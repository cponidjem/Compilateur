#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LONGUEUR 80
#define MAX 1024

typedef struct Symbole{
	char variable[LONGUEUR];
	char type[LONGUEUR];
	int profondeur;
	int temp;
	int adresse;
} Symbole;

typedef struct Element Element;
struct Element{
	Symbole symbole;
    Element *suivant;
};

typedef struct Pile Pile;
struct Pile{
    Element *sommet;
};

Pile *initialiser();
void empiler(Pile *pile, char variable[LONGUEUR],	char type[LONGUEUR],	int profondeur, int temp);
void depiler(Pile *pile);
void depilerProfondeur(Pile *pile, int profondeur);
int getAdresse(Pile *pile,char variable[LONGUEUR], int profondeur);
int getDerniereAdresse(Pile *pile);
void afficherPile(Pile *pile);
