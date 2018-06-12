#include "pile.h"


Pile *initialiser(){
    Pile *pile = malloc(sizeof(*pile));
    pile->sommet = NULL;
}

void empiler(Pile *pile, char variable[LONGUEUR],	char type[LONGUEUR],	int profondeur, int temp){
	if (pile == NULL){
        exit(EXIT_FAILURE);
    }
	if (getAdresse(pile, variable, profondeur)==-1 || temp==1){
		Symbole symbole;
		Element *nouveau = malloc(sizeof(*nouveau));

		if (nouveau == NULL){
		    exit(EXIT_FAILURE);
		}

		strcpy(symbole.variable,variable);
		strcpy(symbole.type,type);
		symbole.profondeur = profondeur;
		symbole.temp = temp;
		if ((*pile).sommet == NULL) {
			symbole.adresse = 0;			
		} else {
			symbole.adresse = (*(*pile).sommet).symbole.adresse +1;
		}

		(*nouveau).symbole = symbole;
		(*nouveau).suivant = (*pile).sommet;

		(*pile).sommet = nouveau;
	}
}

void depiler(Pile *pile){	
	if (pile == NULL){
        exit(EXIT_FAILURE);
    }

    Element *elementDepile = (*pile).sommet;
    if (pile != NULL && (*pile).sommet != NULL){
        (*pile).sommet = (*elementDepile).suivant;
        free(elementDepile);
    }
}

void depilerProfondeur(Pile *pile, int profondeur){
	if (pile == NULL){
        exit(EXIT_FAILURE);
    }

	Element *elementDepile = (*pile).sommet;
    while (pile != NULL && (*pile).sommet != NULL && (*elementDepile).symbole.profondeur >= profondeur){
			(*pile).sommet = (*elementDepile).suivant;
		    free(elementDepile);
			elementDepile = (*pile).sommet;       
    }
	
}

int getAdresse(Pile *pile,char variable[LONGUEUR], int profondeur){
	if (pile == NULL){
        exit(EXIT_FAILURE);
    }

	int retAdresse = -1;
	Element *actuel = (*pile).sommet;
    while (actuel != NULL){
		if(strcmp((*actuel).symbole.variable,variable) == 0 && (*actuel).symbole.profondeur == profondeur){
			retAdresse = (*actuel).symbole.adresse;
			break;
		}
		actuel = (*actuel).suivant;
    }
	return retAdresse;
}

int getDerniereAdresse(Pile *pile){
	if (pile == NULL){
        exit(EXIT_FAILURE);
    }
	return (*(*pile).sommet).symbole.adresse;

}

void afficherPile(Pile *pile){
    if (pile == NULL){
        exit(EXIT_FAILURE);
    }
    Element *actuel = (*pile).sommet;

    while (actuel != NULL){
        printf("adresse: %d | variable: %s | type: %s | profondeur: %d | temp: %d\n",(*actuel).symbole.adresse,(*actuel).symbole.variable,(*actuel).symbole.type,(*actuel).symbole.profondeur,(*actuel).symbole.temp);
        actuel = (*actuel).suivant;
    }
    printf("\n");
}


