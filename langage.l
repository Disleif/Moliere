%option noyywrap

%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "langage.bison.hpp"
%}

%%
"Afficher"|"Ecrire"|"Affichage de" { return PRINT; }
"Nouvelle variable"                { return NEWVARM; }
"nouvelle variable"                { return NEWVARm; }
"valant"                           { return NEWEQ; }
"Assigner à"|"Donner à"            { return ASSIGN; }
"la valeur"                        { return ASSIGN2; }
"Si"                               { return IF; }
"Sinon"                            { return ELSE; }
"Tant que"                         { return WHILE; }
"Effectuer puis répéter tant que"  { return DOWHILE; }
"Pour"                             { return FOR; }
"Fin"                              { return END; }
"Aller à"                          { return GOTO; }
"Si oui :"|"Si oui, faire :"       { return TERNOP1; }
", Si non :"|", Si non, faire :"|", Sinon :"|", Sinon, faire :" { return TERNOP2; }
", si non :"|", si non, faire :"|", sinon :"|", sinon, faire :" { return TERNOP2; }

"est "?"supérieur à"         { return SUP; }
"est "?"inférieur à"         { return INF; }
"est "?"supérieur ou égal à" { return SUPEQ; }
"est "?"inférieur ou égal à" { return INFEQ; }
"est "?"égal à"|"vaut"       { return EQ; }
"est "?"différent de"        { return INEQ; }

[0-9]+([0-9]*)?(([Ee][+-]?[0-9])|(\,)[0-9]+)? { yylval.valeur = atof(yytext); return NUM; }
[A-Za-z_][A-Za-z_0-9]*                        { strcpy(yylval.nom, yytext); return VAR; }

"++" { return INC; }
"--" { return DEC; }
"+"  { return ADD; }
"-"  { return SUB; }
"*"  { return MUL; }
"/"  { return DIV; }

"(" { return '('; }
")" { return ')'; }
"," { return ','; }
"?" { return TERNARY; }
", faire "?":" { return ':'; }
\".*\" { strcpy(yylval.nom, yytext); return STR; }

"°".* { }
\n    { }
\r    { }
\t    { }
" "   { }
"."   { return '.'; }

<<EOF>> { printf("Le programme est correct !\n\n"); return 0; }
.       { printf("Erreur lexicale : %s\n\n", yytext); return 0; }

%%
