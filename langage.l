%option noyywrap

%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "langage.bison.hpp"
%}

%%
"Afficher" { return PRINT; }
"vaut"     { return ASSIGN; }
"Si"       { return IF; }
"Sinon"    { return ELSE; }
"Fin"      { return END; }
"Aller à"  { return GOTO; }

[0-9]+(\,[0-9]*)?([Ee][+-]?[0-9]+)? { yylval.valeur = atof(yytext); return NUM; }
[A-Za-z_][A-Za-z_0-9]*              { strcpy( yylval.nom, yytext); return VAR; }

"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }

"(" { return '('; }
")" { return ')'; }
":" { return ':'; }

"supérieur à"            { return SUP; }
"inférieur à"            { return INF; }
"supérieur ou égal à"    { return SUPEQ; }
"inférieur ou égal à"    { return INFEQ; }
"équivalent à"           { return EQ; }
"n'est pas équivalent à" { return INEQ; }

"//".*   { }
\n       { return '\n'; }
\r       { }
\t       { }
" "      { }

<<EOF>> { printf("Le programme est correct!\n\n"); return 0; }
.       { printf("Erreur lexicale : %s\n\n", yytext); return 0; }

%%
