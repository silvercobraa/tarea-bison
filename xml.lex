/* DEFINICIONES */

%{
	#include <stdio.h>
	#include  "xml.tab.h"

	extern int yyerror(char*);
%}

SLASH \/
MENOR <
MAYOR >
SIGNO_PREGUNTA \?
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

ATRIBUTO {NOMBRE}{ESPACIO}*{IGUAL}{ESPACIO}*{STRING}

NO_MAYOR_MENOR [^<>]
CONTENIDO {NO_MAYOR_MENOR}+

ABRE_TAG {MENOR}{NOMBRE}({ESPACIO}+{ATRIBUTO})*{ESPACIO}*{MAYOR}
CIERRA_TAG {MENOR}{SLASH}{NOMBRE}{ESPACIO}*{MAYOR}
TAG_VACIO {MENOR}{NOMBRE}({ESPACIO}+{ATRIBUTO})*{ESPACIO}*{SLASH}{MAYOR}

NUMERO_VERSION 1\.[0-9]+
VERSION <\?xml{BLANCO}version{BLANCO}?={BLANCO}?{COMILLA}{NUMERO_VERSION}{COMILLA}\?>

TAG_SIGNO_PREGUNTA <\?.*\?>
TAG_SIGNO_EXCLAMACION <!.*>

%%

{BLANCO} {
	/* Se ignora el whitespace */
}

{VERSION} {
	return V;
}

{CONTENIDO} {
	printf("CONTENIDO: %s\n", yytext);
	return C;
}

{TAG_VACIO} {
	printf("TAG_VACIO: %s\n", yytext);
	return TV;
}

{ABRE_TAG} {
	printf("ABRE_TAG: %s\n", yytext);
	return AT;
}

{CIERRA_TAG} {
	printf("CIERRA_TAG: %s\n", yytext);
	return CT;
}

. {
	printf("SIMBOLO DESCONOCIDO: %s\n", yytext);
} // cualquier otra wea...

%%
