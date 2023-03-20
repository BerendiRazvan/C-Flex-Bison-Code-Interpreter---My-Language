%{

 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>

 extern int yylex();
 extern int yyparse();
 extern FILE* yyin;

 void yyerror(const char* s);
 extern int liniaCurenta;

%}

%union {
  char sval[100];
}


// cuvinte cheie
%token<sval> ID
%token<sval> CONST
%token INCLUDE
%token IOSTREAM
%token USING
%token NAMESPACE
%token STD
%token INT
%token MAIN
%token CIN
%token COUT
%token RETURN
%token INOP
%token OUTOP
%token<sval> SEMN
%token EQUAL
%token SEMICOLON
%token BRACEL
%token BRACER
%token COMMA

%%


program :
        {
            printf("\nbits 32\n\n");
            printf("global start\n\n");
            printf("extern printf\n");
            printf("import printf msvcrt.dll\n");
            printf("extern scanf\n");
            printf("import scanf msvcrt.dll\n");
            printf("extern exit\n");
            printf("import exit msvcrt.dll\n\n");

            printf("segment data use32 class=data\n");
            printf("\tformat db \"%%d\", 0\n");
            printf("\tendl db \`\\n\`, 0\n");
        }
        INCLUDE IOSTREAM USING NAMESPACE STD SEMICOLON INT MAIN BRACEL lista_declaratii
        {
            printf("\nsegment code use32 class=code\n");
            printf("\tstart:\n");
        }
        lista_operatii return_final BRACER
        ;

lista_declaratii : declaratie
                 | declaratie lista_declaratii
                 ;

lista_operatii : operatie
               | operatie lista_operatii
               ;

declaratie : INT nume_variabile SEMICOLON
           ;

nume_variabile : ID
               {
                    printf("\t%s dd 0\n", $1);
               }
               | ID COMMA nume_variabile
               {
                    printf("\t%s dd 0\n", $1);
               }
               ;

operatie : atribuire
         | intrare
         | iesire
         ;

atribuire : ID EQUAL expr SEMICOLON
          {
                printf("\t\tmov [%s], eax\n\n", $1);
          }
          ;

expr : ID
     {
        printf("\t\tmov eax, %s\n", $1);
     }
     | CONST
     {
        printf("\t\tmov eax, %s\n", $1);
     }
     | ID SEMN ID
     {
        printf("\t\tmov eax, [%s]\n", $1);
        printf("\t\tmov ebx, [%s]\n", $3);
        if(strcmp($2,"+")==0)
            printf("\t\tadd eax, ebx\n");
        if(strcmp($2,"-")==0)
            printf("\t\tsub eax, ebx\n");
        if(strcmp($2,"*")==0)
            printf("\t\tmul ebx\n");
        if(strcmp($2,"/")==0)
            printf("\t\tdiv ebx\n");
     }
     | ID SEMN CONST
     {
        printf("\t\tmov eax, [%s]\n", $1);
        printf("\t\tmov ebx, %s\n", $3);
        if(strcmp($2,"+")==0)
            printf("\t\tadd eax, ebx\n");
        if(strcmp($2,"-")==0)
            printf("\t\tsub eax, ebx\n");
        if(strcmp($2,"*")==0)
            printf("\t\tmul ebx\n");
        if(strcmp($2,"/")==0)
            printf("\t\tdiv ebx\n");
     }
     | CONST SEMN ID
     {
        printf("\t\tmov eax, %s\n", $1);
        printf("\t\tmov ebx, [%s]\n", $3);
        if(strcmp($2,"+")==0)
            printf("\t\tadd eax, ebx\n");
        if(strcmp($2,"-")==0)
            printf("\t\tsub eax, ebx\n");
        if(strcmp($2,"*")==0)
            printf("\t\tmul ebx\n");
        if(strcmp($2,"/")==0)
            printf("\t\tdiv ebx\n");
     }
     | CONST SEMN CONST
     {
        printf("\t\tmov eax, %s\n", $1);
        printf("\t\tmov ebx, %s\n", $3);
        if(strcmp($2,"+")==0)
            printf("\t\tadd eax, ebx\n");
        if(strcmp($2,"-")==0)
            printf("\t\tsub eax, ebx\n");
        if(strcmp($2,"*")==0)
            printf("\t\tmul ebx\n");
        if(strcmp($2,"/")==0)
            printf("\t\tdiv ebx\n");
     }
     ;


intrare : CIN INOP ID SEMICOLON
        {
                printf("\t\tpush dword %s\n", $3);
                printf("\t\tpush dword format\n");
                printf("\t\tcall [scanf]\n");
                printf("\t\tadd esp, 4 * 2\n\n");
        }
        ;

iesire : COUT OUTOP ID SEMICOLON
       {
                printf("\t\tpush dword [%s]\n", $3);
                printf("\t\tpush dword format\n");
                printf("\t\tcall [printf]\n");
                printf("\t\tadd esp, 4 * 2\n\n");

                printf("\t\tpush dword endl\n");
                printf("\t\tcall [printf]\n");
                printf("\t\tadd esp, 4\n\n");
       }
       ;



return_final : RETURN CONST SEMICOLON
             {
                    printf("\tpush dword 0\n");
                    printf("\tcall [exit]\n");
             }
             ;



%%

int main(int argc, char* argv[]) {
  FILE* f;
  char filename[100];
  printf("\nPROGRAM FILE: ");
  scanf("%s", filename);
  f = fopen(filename, "r");
  if (!f) {
   printf("\nCannot open file\n");
   return -1;
  }

  printf("\nAnalysis started\n");
  printf("\n---------------------------------ASM---------------------------------\n");

  yyin = f;
  do {
    yyparse();
  } while (!feof(yyin));


  printf("\n---------------------------------------------------------------------\n");
  printf("\nAnalysis completed\n\n");

  fclose(f);
}

void yyerror(const char* s) {
  printf("ERROR: line %d - %s\n\n", liniaCurenta, s);
  exit(1);
}



