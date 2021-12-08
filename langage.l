%option noyywrap

%{
  #include <string>
  #include <algorithm>
  #include "langage.bison.hpp"

  using namespace std;
%}

%%
"Afficher"|"Ecrire"|"Affichage de" { return PRINT; }
"Demander"                         { return ASK; }
"Nouvelle variable"                { return NEWVARM; }
"nouvelle variable"                { return NEWVARm; }
"valant"|"qui vaut"                { return NEWEQ; }
"Assigner à"|"Donner à"            { return ASSIGN; }
"la valeur"                        { return ASSIGN2; }
"la valeur de"                     { return ASSIGN3; }
"Si"                               { return IF; }
"Sinon"                            { return ELSE; }
"Tant que"                         { return WHILE; }
"Effectuer puis répéter tant que"  { return DOWHILE; }
"Pour"                             { return FOR; }
"tant que"                         { return FORCOND; }
"Fin"                              { return END; }
"Aller à"                          { return GOTO; }
"Fonction"                         { return FUNC; }
"Appeler"                          { return CALL; }

"Si oui :"|"Si oui, faire :"                                    { return TERNOP1; }
", Si non :"|", Si non, faire :"|", Sinon :"|", Sinon, faire :" { return TERNOP2; }
", si non :"|", si non, faire :"|", sinon :"|", sinon, faire :" { return TERNOP2; }

"est "?"supérieur à"         { return SUP; }
"est "?"inférieur à"         { return INF; }
"est "?"supérieur ou égal à" { return SUPEQ; }
"est "?"inférieur ou égal à" { return INFEQ; }
"est "?"égal à"|"vaut"       { return EQ; }
"est "?"différent de"        { return INEQ; }

[0-9]+(,[0-9]+)?([Ee][+-]?[0-9]+)? { std::string s = yytext; replace(s.begin(), s.end(), ',', '.'); yylval.valeur = stod(s); return NUM; }
[A-Za-z_][A-Za-z_0-9]*             { strcpy(yylval.nom, yytext); return VAR; }
\|[A-Za-z_][A-Za-z_0-9]*\|         { strcpy(yylval.nom, yytext); return LABEL; }
\".*\"                             { strcpy(yylval.nom, yytext); return STR; }

"++" { return INC; }
"--" { return DEC; }
"+"  { return ADD; }
"-"  { return SUB; }
"*"  { return MUL; }
"/"  { return DIV; }
"%"  { return MOD; }

"("            { return '('; }
")"            { return ')'; }
","            { return ','; }
"?"            { return TERNARY; }
", faire "?":" { return ':'; }

"°".* { }
\n    { }
\r    { }
\t    { }
" "   { }
"."   { return '.'; }

<<EOF>> { return 0; }
.       { printf("Erreur lexicale : %s\n\n", yytext); return 0; }

%%
