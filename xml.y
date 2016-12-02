%{
/* DEFINICIONES C */
#include <stdio.h>
#include <stdlib.h>

int yyerror(char*);
int yylex();

int hojas = 0;
int altura = 0;
int hermanos = 0;

%}

/* DEFINICION TOKENS */
%token TV // tag vacio
%token AT // abre tag
%token CT // cierra tag
%token C // contenido tag
%token TI // tag interrogacion

%start Documento

%%
/* GRAMATICA */
Documento:
    Encabezado {
        fprintf(stderr, "Encabeza3\n");
    }
    | Encabezado Arbol {
        fprintf(stderr, "Encabezado Arbol\n");
    }
;

Encabezado:
    Encabezado TI {
        fprintf(stderr, "Encabezado TI\n");
    }
    | TI {
        fprintf(stderr, "TI\n");
    }

Arbol:
    Arbol Arbol {
        fprintf(stderr, "Arbol Arbol\n");
    }
    | AT Arbol CT {
        fprintf(stderr, "AT Arbol CT\n");
    }
    | Hoja {
        fprintf(stderr, "Hoja\n");
    }
;

Hoja:
    /*epsilon*/ {

    }
    | AT C CT {
        hojas++;
        fprintf(stderr, "AT C CT\n");
    }
    | TV {
        hojas++;
        fprintf(stderr, "TV\n");
    }
;

%%

/* CODIGO C (+MAIN) */

int yyerror(char *s) {
    printf("YYERROR: %s\n", s);
    /*exit(1);*/
}

int main(int argc, char* argv[]) {
    int res = yyparse();
    printf("res: %d\n", res);
    if (!res) {
        fprintf(stderr, "Successful parsing.\n");
    }
    else {
        fprintf(stderr, "Errors found.\n");
    }
}
