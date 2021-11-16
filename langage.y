%{
    #include <iostream>
    #include <stdio.h>
    #include <stdlib.h>
    #include <cmath>   
    #include <map>
    #include <string>

    using namespace std;

    extern int yylex ();
    extern char* yytext;
    extern FILE* yyin;
    int yyerror(char *s);

    // Map associant chaque variable à sa valeur
    map<string,double> variables ;
%}

%union {
    double valeur;
    char nom[50];
}

%token <valeur> NUM
%token <nom> VAR
%type <valeur> expr
%token PRINT
%token VAUT

%left '+' '-'
%right '*' '/'

%%
bloc :
/* Epsilon */
| bloc instruction '\n'   

instruction :
/* Epsilon */
| expr { printf("Résultat : %g", $1); }
| VAR VAUT expr {
    variables[$1] = $3;
}
| PRINT expr { cout << $2; }

expr :
NUM { $$ = $1; }
| VAR { 
    try {
        $$ = variables.at($1);
    }
    catch(...) {
        printf("La variable %s est utilisée mais jamais initialisée", $1);
        variables[$1] = 0;
    }
 }
| '(' expr ')' { $$ = $2; }
| expr '+' expr { $$ = $1 + $3; }
| expr '-' expr { $$ = $1 - $3; }   		
| expr '*' expr { $$ = $1 * $3; }		
| expr '/' expr { $$ = $1 / $3; }    
%%

int yyerror(char *s) {					
    printf("%s : %s\n", s, yytext);
}

int main(int argc, char **argv) {
  printf("\n------------------------------------\n");
  printf("| Langage de Programmation Molière |\n");
  printf("------------------------------------\n\n");

  // Code pour traiter un fichier au lieu de l'entrée clavier
  if ( argc > 1 )
    yyin = fopen( argv[1], "r" );
  else
    yyin = stdin;

  yyparse();						

  return 0;
}