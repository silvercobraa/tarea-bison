/* DEFINICIONES */

SLASH \/
MENOR <
MAYOR >
SIGNO_PREGUNTA \?
IGUAL =

ESPACIO (\ )
BLANCO (\ |\t|\n)+

CARACTER_INICIAL_NOMBRE :|[A-Z]|_|[a-z]
CARACTER_NOMBRE {CARACTER_INICIAL_NOMBRE}|-|\.|[0-9]
NOMBRE {CARACTER_INICIAL_NOMBRE}({CARACTER_NOMBRE})*

COMILLA \"
NO_COMILLA [^"]
STRING {COMILLA}{NO_COMILLA}*{COMILLA}

ATRIBUTO {NOMBRE}{ESPACIO}*{IGUAL}{ESPACIO}*{STRING}
CONTENIDO .+

ABRE_TAG {MENOR}{SLASH}{NOMBRE}({ESPACIO}+{ATRIBUTO})*{ESPACIO}*{MAYOR}
CIERRA_TAG {MENOR}{SLASH}{NOMBRE}{ESPACIO}*{MAYOR}
TAG_VACIO {MENOR}{SLASH}{NOMBRE}({ESPACIO}+{ATRIBUTO})*{ESPACIO}*{SLASH}{MAYOR}

NUMERO_VERSION 1\.[0-9]+
VERSION <\?xml{BLANCO}version{BLANCO}?={BLANCO}?{COMILLA_DOBLE}{NUMERO_VERSION}{COMILLA_DOBLE}\?>

/*NOMBRES {NOMBRE}(\ {NOMBRE})*/

TAG_SIGNO_PREGUNTA <\?.*\?>
TAG_SIGNO_EXCLAMACION <!.*>


%{
	//#include  "calc.tab.h"

%}

%%

CONTENIDO {}
ABRE_TAG {}
CIERRA_TAG {}
TAG_VACIO {}

%%


/*CODIGO USUARIO*/
int main(int argc, char* argv[])
{
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	if (tags_abiertos != 0)
	{
		printf("\nHay %d tag(s) sin cerrar\n", tags_abiertos);
		return 2;
	}
	printf("No se encontraron errores en el documento.\n");
	// printf("TAGS ABIERTOS: %d\n", tags_abiertos);
}