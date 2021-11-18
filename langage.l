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
"Tant que" { return WHILE; }
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

"est supérieur à"         { return SUP; }
"est inférieur à"         { return INF; }
"est supérieur ou égal à" { return SUPEQ; }
"est inférieur ou égal à" { return INFEQ; }
"est égal à"              { return EQ; }
"est différent de"        { return INEQ; }

"°".* { }
\n    { return '\n'; }
\r    { }
\t    { }
" "   { }

<<EOF>> { printf("Le programme est correct!\n\n"); return 0; }
.       { printf("Erreur lexicale : %s\n\n", yytext); return 0; }

%%
