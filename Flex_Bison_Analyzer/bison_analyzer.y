%{

 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>

 // Declare stuff from Flex that Bison needs to know about:
 extern int yylex();
 extern int yyparse();
 extern FILE* yyin;

 void yyerror(const char* s);
 extern void printfInfo();

 extern int liniaCurenta;
 void show();

%}

// cuvinte cheie
%token ID
%token CONST
%token MSG
%token INCLUDE
%token IOSTREAM
%token USING
%token NAMESPACE
%token STD
%token INT
%token MAIN
%token DOUBLE
%token CIN
%token COUT
%token RETURN
%token IF
%token WHILE
%token EQUAL
%token NOTEQUAL
%token INOP
%token OUTOP

%token THEN
%token ENDIF

%%


program : INCLUDE IOSTREAM USING NAMESPACE STD ';' INT MAIN '{' lista_instructiuni return_final '}'
        ;

lista_instructiuni : instructiuni
                   | instructiuni lista_instructiuni
                   ;

instructiuni : lista_declaratii
             | lista_operatii
             | lista_declaratii lista_operatii
             ;

lista_declaratii : declaratie
                 | declaratie lista_declaratii
                 ;

lista_operatii : operatie
               | operatie lista_operatii
               ;

declaratie : tip nume_variabile ';'
           ;

tip : INT
    | DOUBLE
    ;

nume_variabile : nume
               | nume ',' nume_variabile
               ;

nume : ID
     | ID '[' CONST ']'
     ;

operatie : atribuire
         | intrare
         | iesire
         | instr_rel
         | instr_ciclare
         | instr_myif
         ;

instr : operatie ;


instr_myif : IF '(' ID ')' THEN instr ENDIF
           ;

atribuire : ID '=' expr ';'
          ;

expr : expr semn expr
     | CONST
     | ID
     ;

semn : '+'
     | '-'
     | '*'
     | '%'
     | '/'
     ;

intrare : CIN INOP ID ';'
        ;

iesire : COUT OUTOP date_iesire ';'
       ;

date_iesire : expr
            | MSG
            ;

instr_rel : IF relatie '{' lista_instructiuni '}'
          ;

instr_ciclare : WHILE relatie '{' lista_instructiuni '}'
              ;

relatie : '(' elem_relatie comparator elem_relatie ')'
        ;

elem_relatie : relatie
             | CONST
             | ID
             ;


comparator : '<'
           | '>'
           | EQUAL
           | NOTEQUAL
           ;

return_final : RETURN CONST ';'
       ;


%%

int main(int argc, char* argv[]) {
  FILE* f;
  char filename[100];
  printf("FILE: ");
  scanf("%s", filename);
  f = fopen(filename, "r");
  if (!f) {
   printf("Cannot open file\n");
   return -1;
  }
  printf("\nAnalysis started\n\n");
  yyin = f;
  do {
    yyparse();
  } while (!feof(yyin));
  printf("\nAnalysis completed\n");
  show();
  fclose(f);
}

void yyerror(const char* s) {
  printf("\nERROR: line %d!\n%s\n\n", liniaCurenta, s);
  exit(1);
}






