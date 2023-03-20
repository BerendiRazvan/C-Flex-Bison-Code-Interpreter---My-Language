/* analizor pentru un MLP din C++ */

%{
   /* definitii accesibile in yylex si main */
  #include "bison_analyzer.tab.h"
  #include <string.h>

  struct Element {
    int cod;
    char simbol[20];
    char tip[20];
  };

  struct TS {
    struct Element elemente[50];
    int pozCurenta;
    int codCurent;
  };

  struct FIP {
    int coduri[1000];
    int pozCurenta;
  };


  struct TS tsIds = { .pozCurenta = 0, .codCurent = 0 };
  struct TS tsConstants = { .pozCurenta = 0, .codCurent = 0 };
  struct TS tsMessages = { .pozCurenta = 0, .codCurent = 0 };

  struct FIP fip = {.pozCurenta = 0 };
  int liniaCurenta = 1;
  void adaugaFIP(int cod);

  void adaugaTS(int codFIP, char simbol[]);

%}


  /* reguli */
id       [a-zA-Z_]+[a-zA-Z_0-9]*
const    0|[1-9]+[0-9]*|[-][1-9]+[0-9]*|(0|[1-9]+[0-9]*|[+-][1-9]+[0-9])\.([1-9]+[0-9]*|[+-][1-9]+[0-9])
message  \"[a-zA-Z_0-9 =.,:;-]*\"
%%


"#include" { adaugaFIP(4); printf("token - RESERVED WORD: %s\n", "#include"); return INCLUDE; }
"<iostream>" { adaugaFIP(5); printf("token - RESERVED WORD: %s\n", "<iostream>"); return IOSTREAM; }
"using" { adaugaFIP(6); printf("token - RESERVED WORD: %s\n", "using"); return USING; }
"namespace" { adaugaFIP(7); printf("token - RESERVED WORD: %s\n", "namespace"); return NAMESPACE; }
"std" { adaugaFIP(8); printf("token - RESERVED WORD: %s\n", "std"); return STD; }
"int" { adaugaFIP(9); printf("token - RESERVED WORD: %s\n", "int"); return INT; }
"main()" { adaugaFIP(10); printf("token - RESERVED WORD: %s\n", "main()"); return MAIN; }
"double" { adaugaFIP(11); printf("token - RESERVED WORD: %s\n", "double"); return DOUBLE; }
"cin" { adaugaFIP(12); printf("token - RESERVED WORD: %s\n", "cin"); return CIN; }
"cout" { adaugaFIP(13); printf("token - RESERVED WORD: %s\n", "cout"); return COUT; }
"return" { adaugaFIP(14); printf("token - RESERVED WORD: %s\n", "return"); return RETURN; }
"if" { adaugaFIP(15); printf("token - RESERVED WORD: %s\n", "if"); return IF; }
"while" { adaugaFIP(16); printf("token - RESERVED WORD: %s\n", "while"); return WHILE; }
"+"  { adaugaFIP(17); printf("token - OPERATOR: %s\n", "+"); return '+'; }
"-"  { adaugaFIP(18); printf("token - OPERATOR: %s\n", "-"); return '-'; }
"*"  { adaugaFIP(19); printf("token - OPERATOR: %s\n", "*"); return '*'; }
"%"  { adaugaFIP(20); printf("token - OPERATOR: %s\n", "%"); return '%'; }
"/"  { adaugaFIP(21); printf("token - OPERATOR: %s\n", "/"); return '/'; }
"="  { adaugaFIP(22); printf("token - OPERATOR: %s\n", "="); return '='; }
"<"  { adaugaFIP(23); printf("token - OPERATOR: %s\n", "<"); return '<'; }
">"  { adaugaFIP(24); printf("token - OPERATOR: %s\n", ">"); return '>'; }
"=="  { adaugaFIP(25); printf("token - OPERATOR: %s\n", "=="); return EQUAL; }
"!="  { adaugaFIP(26); printf("token - OPERATOR: %s\n", "!="); return NOTEQUAL; }
";"  { adaugaFIP(27); printf("token - SEPARATOR: %s\n", ";"); return ';'; }
"{"  { adaugaFIP(28); printf("token - SEPARATOR: %s\n", "{"); return '{'; }
"}"  { adaugaFIP(29); printf("token - SEPARATOT: %s\n", "}"); return '}'; }
"["  { adaugaFIP(30); printf("token - SEPARATOT: %s\n", "["); return '['; }
"]"  { adaugaFIP(31); printf("token - SEPARATOT: %s\n", "]"); return ']'; }
"("  { adaugaFIP(32); printf("token - SEPARATOT: %s\n", "("); return '('; }
")"  { adaugaFIP(33); printf("token - SEPARATOT: %s\n", ")"); return ')'; }
","  { adaugaFIP(34); printf("token - SEPARATOT: %s\n", ","); return ','; }
"."  { adaugaFIP(35); printf("token - SEPARATOT: %s\n", "."); return '.'; }
">>"  { adaugaFIP(36); printf("token - SEPARATOT: %s\n", ">>"); return INOP; }
"<<"  { adaugaFIP(37); printf("token - SEPARATOT: %s\n", "<<"); return OUTOP; }

"then" { adaugaFIP(39); printf("token - RESERVED WORD: %s\n", "then"); return THEN; }
"endif" { adaugaFIP(40); printf("token - RESERVED WORD: %s\n", "endif"); return ENDIF; }

{id} { adaugaTS(1, yytext); printf("token - ID: %s\n", yytext); return ID; }
{const}  { adaugaTS(2, yytext); printf("token - CONSTANT: %s\n", yytext); return CONST; }
{message} { adaugaTS(3, yytext); printf("token - MESSAGE: %s\n", yytext); return MSG; }
[ \t]+   /* whitespace */
[\n] { liniaCurenta++; printf("NEW LINE\n"); }
.  { printf("ERROR: %s - token/atom nespecificat pe linia %d!\n", yytext, liniaCurenta);
     return -1; }


%%


void adaugaFIP(int cod) {
  fip.coduri[fip.pozCurenta] = cod;
  fip.pozCurenta++;
 }

void adaugaTS(int codFIP, char simbol[]) {
  adaugaFIP(codFIP);

  for(int i = 0; i < tsIds.pozCurenta; i++) {
    if (strcmp(tsIds.elemente[i].simbol, simbol) == 0) return;
  }

  for(int i = 0; i < tsConstants.pozCurenta; i++) {
    if (strcmp(tsConstants.elemente[i].simbol, simbol) == 0) return;
  }

  for(int i = 0; i < tsMessages.pozCurenta; i++) {
    if (strcmp(tsMessages.elemente[i].simbol, simbol) == 0) return;
  }

  char tip[20];

  if(codFIP == 1){
    tsIds.elemente[tsIds.pozCurenta].cod = tsIds.codCurent;
    strcpy(tsIds.elemente[tsIds.pozCurenta].simbol, simbol);
    strcpy(tip,"ID");
    strcpy(tsIds.elemente[tsIds.pozCurenta].tip, tip);
    tsIds.codCurent++;
    tsIds.pozCurenta++;
  }

  if(codFIP == 2){
    tsConstants.elemente[tsConstants.pozCurenta].cod = tsConstants.codCurent;
    strcpy(tsConstants.elemente[tsConstants.pozCurenta].simbol, simbol);
    strcpy(tip,"CONSTANT");
    strcpy(tsConstants.elemente[tsConstants.pozCurenta].tip, tip);
    tsConstants.codCurent++;
    tsConstants.pozCurenta++;
  }

  if(codFIP == 3){
    tsMessages.elemente[tsMessages.pozCurenta].cod = tsMessages.codCurent;
    strcpy(tsMessages.elemente[tsMessages.pozCurenta].simbol, simbol);
    strcpy(tip,"MESSAGE");
    strcpy(tsMessages.elemente[tsMessages.pozCurenta].tip, tip);
    tsMessages.codCurent++;
    tsMessages.pozCurenta++;
  }

}



int yywrap() {}
void show() {

  printf("\n----- FIP -----\n");
  for (int i = 0; i < fip.pozCurenta; i++)
    printf("%d ", fip.coduri[i]);

  printf("\n");

  FILE* fIds;
  FILE* fConstants;
  FILE* fMessages;

  fIds = fopen("tsIds", "w");
  fConstants = fopen("tsConstants", "w");
  fMessages = fopen("tsMessages", "w");

  printf("\n----- TS - Ids -----\n");
  for (int i = 0; i < tsIds.pozCurenta; i++){
    printf("COD=%d -> SYMBOL: %s\n", i, tsIds.elemente[i].simbol);
    fprintf(fIds, "COD=%d -> SYMBOL: %s\n", i, tsIds.elemente[i].simbol);
  }

  printf("\n----- TS - Constants -----\n");
  for (int i = 0; i < tsConstants.pozCurenta; i++){
    printf("COD=%d -> SYMBOL: %s\n", i, tsConstants.elemente[i].simbol);
    fprintf(fConstants, "COD=%d -> SYMBOL: %s\n", i, tsConstants.elemente[i].simbol);
  }


  printf("\n----- TS - Messages -----\n");
  for (int i = 0; i < tsMessages.pozCurenta; i++){
    printf("COD=%d -> SYMBOL: %s\n", i, tsMessages.elemente[i].simbol);
    fprintf(fMessages, "COD=%d -> SYMBOL: %s\n", i, tsMessages.elemente[i].simbol);
  }

  fclose(fIds);
  fclose(fConstants);
  fclose(fMessages);
}







