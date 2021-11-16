%option noyywrap

%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "langage.bison.hpp"
%}

%%

    /* Nombres */
[0-9]+(\.[0-9]*)?([Ee][+-]?[0-9]+)? {
    yylval.valeur = atof(yytext);
    return NUM;
}

\n {  return '\n'; }
\r { }
\t { }
" " { }

    /* Mots réservés */
"écrire" { return PRINT; }
"vaut" { return VAUT; }

    /* Nom de variable */
[A-Za-z_][A-Za-z_0-9]* {
    strcpy( yylval.nom, yytext); 
    return VAR;
}

    /* Opérateurs */
"+" { return '+'; }
"-" { return '-'; }
"*" { return '*'; }
"/" { return '/'; }
"(" { return '('; }
")" { return ')'; }

    /* Fin du programme */
<<EOF>> {
    printf("\nLe programme est correct!\n\n");
    return 0;
}
. {
    printf ("Erreur lexicale : %s\n\n", yytext);
    return 0;
}

%%
