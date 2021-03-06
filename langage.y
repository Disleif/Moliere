%{
  #include <iostream>
  #include <map>
  #include <vector>
  #include <string>
  #include <stack>

  using namespace std;

  extern int yylex ();
  extern char* yytext;
  extern FILE* yyin;

  int yyerror(char *s);

  class instruction {
  public:
    instruction (const int &c, const double &v=0, const string &n="") : code(c), value(v), name(n) {};
    int code;         // Code de l'instruction (ADD, VAR, ...)
    double value;     // Une valeur si besoin (VAR 5, VAR 2, ...)
    string name;      // Une référence pour la table des données (Nom de variable)
  };

  // Map associant chaque variable à sa valeur
  map<string, double> variables;

  // Map associant chaque label à sa ligne
  map<string, int> adresses;

  // Map associant chaque fonction à sa ligne
  map<string, int> fonctions;

  // Structure pour accueillir le code généré
  vector<instruction> code_genere;
  int ic = 0;

  // Permet d'ajouter une instruction à "code_genere"
  int add_instruction(const int &c, const double &v=0, const string &n="") {
    code_genere.push_back(instruction(c,v,n));
    ic++;
    return 0;
  };
%}

%code requires {
  typedef struct adr {
    int jmp;     // Adresse du jmp
    int jc;      // Adresse du jc
    int jmpfor1; // Jump du for
    int jmpfor2; // Jump du for
    int jmpfor3; // Jump du for
  } type_adresse;
}

%union {
  double valeur;
  char nom[256];
  type_adresse adresse;
}

%type <valeur> expr

%token <valeur> NUM
%token <nom> VAR LABEL STR
%token <adresse> IF WHILE DOWHILE FOR TERNARY FUNC
%token ELSE END GOTO ASSIGN ASSIGN2 ASSIGN3 PRINT ASK JMP JMPCOND TERNOP1 TERNOP2 SUP INF SUPEQ INFEQ EQ INEQ INC DEC NEWVARM NEWVARm NEWEQ CALL FORCOND

%left ADD SUB
%left MOD
%right MUL DIV

%%
bloc :
/* Epsilon */
| bloc label instruction '.'



label :
/* Epsilon */
| LABEL { adresses[$1] = ic; }



instruction :
/* Epsilon */
| expr                    { }
| NEWVARM VAR             { add_instruction(NEWVARM, 0, $2); }
| NEWVARM VAR NEWEQ expr  { add_instruction(NEWEQ, 0, $2); }
| ASSIGN VAR ASSIGN2 expr { add_instruction(ASSIGN, 0, $2); }
| ASSIGN VAR ASSIGN3 VAR  { add_instruction(VAR, 0, $4); add_instruction(ASSIGN, 0, $2); }
| PRINT expr              { add_instruction(PRINT, 0); }
| ASK VAR                 { add_instruction(ASK, 0, $2); }
| PRINT STR               { add_instruction(PRINT, 1, $2); }
| GOTO LABEL              { add_instruction(JMP, -999, $2); }
| CALL VAR                { add_instruction(CALL, 0, $2); }

| IF condition ':' { $1.jc = ic; add_instruction(JMPCOND); }
bloc               { $1.jmp = ic; add_instruction(JMP); code_genere[$1.jc].value = ic; }
ELSE ':' bloc      { }
END                { code_genere[$1.jmp].value = ic; }

| WHILE       { $1.jmp = ic; }
condition ':' { $1.jc = ic; add_instruction(JMPCOND); }
bloc          { }
END           { add_instruction(JMP, $1.jmp); code_genere[$1.jc].value = ic; }

| DOWHILE     { add_instruction(JMP); $1.jmp = ic; }
condition ':' { $1.jc = ic; add_instruction(JMPCOND, $1.jmp); code_genere[$1.jmp - 1].value = ic; }
bloc          { }
END           { add_instruction(JMP, $1.jmp); code_genere[$1.jc].value = ic; }

| FOR NEWVARm VAR NEWEQ expr ',' { add_instruction(NEWEQ, 0, $3); $1.jmp = ic; }
FORCOND condition ','            { $1.jc = ic; add_instruction(JMPCOND); $1.jmpfor1 = ic; add_instruction(JMP); $1.jmpfor2 = ic; }
instruction ':'                  { $1.jmpfor3 = ic; add_instruction(JMP); code_genere[$1.jmpfor1].value = ic; }
bloc                             { add_instruction(JMP, $1.jmpfor2); code_genere[$1.jmpfor3].value = $1.jmp; }
END                              { code_genere[$1.jc].value = ic; }

| condition TERNARY { $2.jc = ic; add_instruction(JMPCOND); }
TERNOP1 
instruction         { $2.jmp = ic; add_instruction(JMP); }
TERNOP2             { code_genere[$2.jc].value = ic; }
instruction         { code_genere[$2.jmp].value = ic; }

| FUNC VAR ':'      { $1.jmp = ic; add_instruction(JMP); fonctions[$2] = ic; }
bloc END            { add_instruction(END); code_genere[$1.jmp].value = ic; } 



expr :
NUM             { add_instruction(NUM, $1); }
| VAR           { add_instruction(VAR, 0, $1); }
| '(' expr ')'  { }
| expr ADD expr { add_instruction(ADD); }
| expr SUB expr { add_instruction(SUB); }
| expr MUL expr { add_instruction(MUL); }
| expr DIV expr { add_instruction(DIV); }
| expr MOD expr { add_instruction(MOD); }
| INC VAR       { add_instruction(VAR, 0, $2); add_instruction(INC); add_instruction(ASSIGN, 0, $2); add_instruction(VAR, 0, $2); }
| VAR INC       { add_instruction(VAR, 0, $1); add_instruction(INC); add_instruction(ASSIGN, 0, $1); add_instruction(VAR, 0, $1); add_instruction(DEC); }
| DEC VAR       { add_instruction(VAR, 0, $2); add_instruction(DEC); add_instruction(ASSIGN, 0, $2); add_instruction(VAR, 0, $2); }
| VAR DEC       { add_instruction(VAR, 0, $1); add_instruction(DEC); add_instruction(ASSIGN, 0, $1); add_instruction(VAR, 0, $1); add_instruction(INC); }



condition :
expr               { }
|  expr SUP expr   { add_instruction(SUP); }
|  expr INF expr   { add_instruction(INF); }
|  expr SUPEQ expr { add_instruction(SUPEQ); }
|  expr INFEQ expr { add_instruction(INFEQ); }
|  expr EQ expr    { add_instruction(EQ); }
|  expr INEQ expr  { add_instruction(INEQ); }
%%

int yyerror(char *s) {
  printf("%s : %s\n", s, yytext);
}

// Fonction pour mieux voir le code généré
// (au lieu des nombres associés au tokens)
string print_code(int ins) {
  switch (ins) {
    case ADD      : return "ADD";
    case SUB      : return "SUB";
    case MUL      : return "MUL";
    case DIV      : return "DIV";
    case MOD      : return "MOD";
    case INC      : return "INC";
    case DEC      : return "DEC";
    case SUP      : return "SUP";
    case INF      : return "INF";
    case SUPEQ    : return "SUPEQ";
    case INFEQ    : return "INFEQ";
    case EQ       : return "EQ";
    case INEQ     : return "INEQ";
    case NUM      : return "NUM";
    case VAR      : return "VAR";
    case NEWVARM  : return "NEWVAR";
    case NEWVARm  : return "NEWVAR";
    case NEWEQ    : return "NEWEQ";
    case ASK      : return "CIN";
    case PRINT    : return "OUT";
    case ASSIGN   : return "MOV";
    case JMP      : return "JMP";
    case JMPCOND  : return "JC";
    case CALL     : return "CALL";
    case END      : return "END";
    default       : return "";
  }
}

// Fonction qui exécute le code générées
void execution (const vector <instruction> &code_genere, map<string,double> &variables) {
  stack<double> pile; // Pile
  stack<double> func; // Pile des fonctions
  int ic = 0;      // Compteur instruction
  double r1, r2;   // Registres

  if (fonctions.find("principale") == fonctions.end()) {
    cout << "Pas de fonction principale déclarée." << endl;
    return;
  } else {
    func.push(code_genere.size()); // A la fin du main on sort de l'exécution
    ic = fonctions["principale"];
  }

  // On exécute chaque instruction
  while (ic < code_genere.size()) {
    instruction ins = code_genere[ic]; // Instruction actuelle
    switch (ins.code) {
      case ADD:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push(r1 + r2);
        ic++;
        break;

      case SUB:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push(r1 - r2);
        ic++;
        break;

      case MUL:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push(r1 * r2);
        ic++;
        break;

      case DIV:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push(r1 / r2);
        ic++;
        break;

      case MOD:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push((int)r1 % (int)r2);
        ic++;
        break;
        
      case INC:
        r1 = pile.top();
        pile.pop();
        pile.push(r1 + 1);
        ic++;
        break;

      case DEC:
        r1 = pile.top();
        pile.pop();
        pile.push(r1 - 1);
        ic++;
        break;

      case SUP:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push(r1 > r2);
        ic++;
        break;

      case INF:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push(r1 < r2);
        ic++;
        break;

      case SUPEQ:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push(r1 >= r2);
        ic++;
        break;

      case INFEQ:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push(r1 <= r2);
        ic++;
        break;

      case EQ:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push(r1 == r2);
        ic++;
        break;

      case INEQ:
        r2 = pile.top();
        pile.pop();
        r1 = pile.top();
        pile.pop();
        pile.push(r1 != r2);
        ic++;
        break;

      case NEWVARM:
        variables[ins.name] = NULL;
        ic++;
        break;

      case NEWEQ:
        r1 = pile.top();
        pile.pop();
        variables[ins.name] = r1;
        ic++;
        break;

      case ASSIGN:
        r1 = pile.top();
        pile.pop();
        if (variables.find(ins.name) == variables.end()) {
          cout << "Variable non initialisée : \"" + ins.name + "\"." << endl;
          return;
        } else {
          variables[ins.name] = r1;
        }
        ic++;
        break;

      case PRINT:
        if (ins.value == 0) {
          r1 = pile.top();
          pile.pop();
          cout << r1 << endl;
        } else {
          string str = ins.name;
          str = str.substr(1, str.size() - 2); // Supression des guillemets

          while (str.length() != 0) {
            if (str.find("{") != string::npos) { // On cherche s'il faut afficher une variable
              unsigned first = str.find("{");
              unsigned last = str.find("}");
              cout << str.substr(0, first);
              string varName = str.substr(first + 1, last - first - 1);
              if (variables.find(varName) == variables.end()) { // Est-ce que la variable existe ?
                cout << "Variable non initialisée : \"" + varName + "\"." << endl;
              return;
              } else {
                cout << variables[varName]; // On affiche la variable
              }
              str = str.substr(last + 1, str.length() - last);
            } else {
              cout << str;            // Aucune variable à afficher, on affiche simplement la string
              str = str.substr(0, 0); // et on sort de la boucle.
            }
          }
          cout << endl;
        }
        ic++;
        break;

      case ASK:
        cout << "> ";
        cin >> r1;
        if (variables.find(ins.name) == variables.end()) {
          cout << "Variable non initialisée : \"" + ins.name + "\"." << endl;
          return;
        } else {
          variables[ins.name] = r1;
        }
        ic++;
        break;

      case NUM:
        pile.push(ins.value);
        ic++;
        break;

      case JMP:
        // Soit on récupère l'adresse à partir de la table, soit on va directement à une instruction donnée
        ic = (ins.value == -999 ? adresses[ins.name] : ins.value);
        break;

      case JMPCOND:
        r1 = pile.top();
        pile.pop();
        // Soit on skip le jump, soit on va à l'instruction donnée
        ic = (r1 ? ic + 1 : (int)ins.value);
        break;

      case CALL:
        func.push(ic + 1);
        ic = fonctions[ins.name];
        break;

      case END:
        r1 = func.top();
        func.pop();
        ic = r1;
        break;

      case VAR:
        try {
          pile.push(variables.at(ins.name));
          ic++;
        }
        catch(...) {
          cout << "Variable non initialisée : \"" << ins.name << "\"." << endl;
          return;
        }
        break;
    }
  }
}

void assembleur(const vector <instruction> &code_genere) {
  cout << "--- Liste des instructions ---" << endl;
  for (int i = 0; i < code_genere.size(); i++){
    auto instruction = code_genere [i];
    cout << i
         << '\t'
         << print_code(instruction.code)
         << '\t'
         << instruction.value
         << '\t'
         << instruction.name
         << endl;
  }
}

int main(int argc, char **argv) {
  printf("\n");
  printf("┌──────────────────────────────────┐\n");
  printf("│ Langage de Programmation Molière │\n");
  printf("└──────────────────────────────────┘\n\n");

  // Code pour traiter un fichier au lieu de l'entrée clavier
  if ( argc > 1 ) yyin = fopen( argv[1], "r" );
  else yyin = stdin;

  yyparse();

  // Affichage de la liste des instructions générées
  //assembleur(code_genere);

  // Maintenant que nos instructions sont corretement générées, on peut exécuter
  execution(code_genere, variables);

  printf("\n");

  return 0;
}
