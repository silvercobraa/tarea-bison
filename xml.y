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
%token TV
%token AT
%token CT
%token C
%token V
%token E
/*%token B*/

%start Documento
%%
/* GRAMATICA */

Documento:
    V {
        printf("V\n");
    }
    | V Arbol {
        printf("V Arbol\n");
    }
    | Arbol {
        printf("Arbol\n");
    }
;

/*VariosArboles:*/
    /* epsilon */ /*{
    printf("epsilon\n");*/
    /*}
    | VariosArboles Arbol {
        hermanos++;
        printf("VariosArboles Arbol, hermanos: %d\n", hermanos);
    }
    | Arbol {
        hermanos++;
        printf("Arbol, hermanos: %d\n", hermanos);
    }
;*/

Arbol:
    Arbol Arbol {
        printf("Arbol Arbol\n");
    }
    | AT Arbol CT {
        printf("AT Arbol CT\n");
    }
    | Hoja {
        printf("Hoja\n");
    }
    /*| AT C CT {
        hojas++;
        printf("AT C CT\n");
    }
    | TV {
        hojas++;
        printf("TV\n");
    }*/
;

Hoja:
    AT C CT {
        hojas++;
        printf("AT C CT\n");
    }
    | TV {
        hojas++;
        printf("TV\n");
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
    /*fprintf(stderr, "hojas: %d\n", hojas);*/
}
