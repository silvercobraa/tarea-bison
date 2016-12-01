%{
/* DEFINICIONES C */
#include <stdio.h>

%}
/* DEFINICION TOKENS */
%token TV /* tag vacio */
%token AT /* abre tag */
%token CT /* cierra tag */
%token C /* contenido */
%token B /* blanco */

%start Debug
%%
/* GRAMATICA */

Debug:
/*    B { $$=$1; printf("$$: %d\n", $$);}*/
    B
    | C
    | TV
    | AT
    | CT
;


Documento:
VariasEtiquetas {printf("Documento\n");}
;

VariasEtiquetas:
/* epsilon */ {printf("epsilon\n");}
| B AT VariasEtiquetas CT B {printf("B AT VariasEtiquetas CT B\n");}
|  B EtiquetaConTexto B {printf("B EtiquetaConTexto B\n");}
;

EtiquetaConTexto:
    AT C CT {printf("EtiquetaConTexto\n");}
;

%%

/* CODIGO C (+MAIN) */
/*int yyerror(char *s)
{
    printf("YYERROR: %s\n", s);
}

int main()
{
    if (yyparse())
        fprintf(stderr, "Successful parsing.\n");
    else
        fprintf(stderr, "error found.\n");
}
*/
