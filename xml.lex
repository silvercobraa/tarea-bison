/* DEFINICIONES */

%{
	#include <stdio.h>
	#include  "xml.tab.h"

	extern int yyerror(char*);

	#define LEN_MAX_MATCH 1024
	#define MAX_TAGS 1024

	int tags_abiertos = 0;
	char stack[MAX_TAGS][LEN_MAX_MATCH];

	void verificar_largo(int);
	void verificar_cantidad_tags();
	void push(char*);
	void pop();

%}

SLASH \/
MENOR <
MAYOR >
INTERROGACION \?
EXCLAMACION !
GUION -
IGUAL =

ESPACIO (\ )
SALTO_LINEA \n
BLANCO (\ |\t|\n)+

CARACTER_INICIAL_NOMBRE :|[A-Z]|_|[a-z]
CARACTER_NOMBRE {CARACTER_INICIAL_NOMBRE}|-|\.|[0-9]
NOMBRE {CARACTER_INICIAL_NOMBRE}({CARACTER_NOMBRE})*

COMILLA \"
NO_COMILLA [^"]
STRING {COMILLA}{NO_COMILLA}*{COMILLA}

COMENTARIO {MENOR}{EXCLAMACION}{GUION}{GUION}(.|\n)*{GUION}{GUION}{MAYOR}
ATRIBUTO {NOMBRE}{ESPACIO}*{IGUAL}{ESPACIO}*{STRING}

NO_MAYOR_MENOR [^<>]
CONTENIDO {NO_MAYOR_MENOR}+

ABRE_TAG {MENOR}{NOMBRE}({ESPACIO}+{ATRIBUTO})*{ESPACIO}*{MAYOR}
CIERRA_TAG {MENOR}{SLASH}{NOMBRE}{ESPACIO}*{MAYOR}
TAG_VACIO {MENOR}{NOMBRE}({ESPACIO}+{ATRIBUTO})*{ESPACIO}*{SLASH}{MAYOR}

TAG_INTERROGACION {MENOR}{INTERROGACION}{NOMBRE}({ESPACIO}+{ATRIBUTO})*{ESPACIO}*{INTERROGACION}{MAYOR}
/*TAG_EXCLAMACION <!.*>*/

%%

{BLANCO} {
	/* Se ignora el whitespace */
}

{COMENTARIO} {
	printf("COMENTARIO\n");
}
{CONTENIDO} {
	printf("CONTENIDO: %s\n", yytext);
	return C;
}

{TAG_VACIO} {
	printf("TAG_VACIO: %s\n", yytext);
	return TV;
}

{TAG_INTERROGACION} {
	return TI;
}

{ABRE_TAG} {
	printf("ABRE_TAG: %s\n", yytext);
	verificar_cantidad_tags();
	fprintf(stderr, "Apilando %s...\n", yytext);
	push(yytext);
	tags_abiertos++;
	return AT;
}

{CIERRA_TAG} {
	printf("CIERRA_TAG: %s\n", yytext);
	tags_abiertos--;
	if (tags_abiertos < 0) {
		printf("\nERROR: no se abrió el tag %s\n", yytext);
		exit(2);
	}
	fprintf(stderr, "tags_abiertos: %d\n", tags_abiertos);
	fprintf(stderr, "yytext: %s\n", yytext);
	fprintf(stderr, "stack: %s\n", stack[tags_abiertos]);
	fprintf(stderr, "Desempilando %s...\n", stack[tags_abiertos]);

	char* tag_leido = &yytext[2];
	char* tope_stack = stack[tags_abiertos];
	int largo_tags = strlen(stack[tags_abiertos]);
	if (strncmp(tag_leido, tope_stack, largo_tags)) {
		printf("\nERROR: falta cerrar el tag %s\n", stack[tags_abiertos]);
		printf("largo_tags: %d\n", largo_tags);
		printf("yytext: %s\n", yytext);
		exit(1);
	}
	return CT;
}

. {
	printf("SIMBOLO DESCONOCIDO: %s\n", yytext);
} // cualquier otra wea...

%%

void verificar_cantidad_tags() {
	if (tags_abiertos >= MAX_TAGS) {
		printf("\nERROR: muchos tags\n");
		exit(5);

	}
}

void push(char* abre_tag) {
	int i;
	for (i = 0; abre_tag[i + 1] != ' ' && abre_tag[i + 1] != '>' && i < LEN_MAX_MATCH - 1; i++) {
		stack[tags_abiertos][i] = abre_tag[i + 1];
	}
	stack[tags_abiertos][i] = '\0';
	fprintf(stderr, "se pusheo %s\nlargo: %d\n", stack[tags_abiertos], strlen(stack[tags_abiertos]));
}
