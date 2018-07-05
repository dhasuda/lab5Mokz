%{

/* Inclusao de arquivos da biblioteca de C */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Definicao dos atributos dos atomos operadores */

#define 	LT 			1
#define		LE 			2
#define		GT 			3
#define 	GE 			4
#define 	EQ 			5
#define 	NE  		6
#define 	PLUS 		7
#define 	MINUS 		8
#define 	MULT 		9
#define 	DIV 		10
#define 	MOD 		11

/*   Definicao dos tipos de identificadores   */

#define     IDPROG      1
#define     IDVAR       2
#define     IDFUNC      3

/* Definicao de constantes para os operadores de quadruplas */

#define		OPOR			1
#define		OPAND	 		2
#define 	OPLT	 		3
#define 	OPLE	 		4
#define		OPGT		    5
#define		OPGE			6
#define		OPEQ			7
#define		OPNE			8
#define		OPMAIS		    9
#define		OPMENOS		    10
#define		OPMULTIP		11
#define		OPDIV			12
#define		OPRESTO		    13
#define		OPMENUN		    14
#define		OPNOT			15
#define		OPATRIB		    16
#define		OPENMOD		    17
#define		NOP			    18
#define		OPJUMP		    19
#define		OPJF			20
#define   PARAM     21
#define   OPCALL    22
#define   OPRET    23
#define   OPREAD   24
#define   OPWRITE   25
#define   OPNONE    26

/* Definicao de constantes para os tipos de operandos de quadruplas */

#define		IDLEOPND		0
#define		VAROPND		    1
#define		INTOPND		    2
#define		REALOPND		3
#define		CHAROPND		4
#define		LOGICOPND	    5
#define		CADOPND		    6
#define		ROTOPND		    7
#define		MODOPND		    8
#define   FUNCAO        9

/*  Definicao dos tipos de variaveis   */

#define     NAOVAR      0
#define     INTEIRO     1
#define     LOGICO      2
#define     REAL        3
#define     CARACTERE   4
#define     FUNCVOID    5

/*   Definicao de outras constantes   */

#define NCLASSHASH  23
#define VERDADE     1
#define FALSO       0
#define MAXDIMS     3

/*  Strings para nomes dos tipos de identificadores  */

char *nometipid[4] = {" ", "IDPROG", "IDVAR", "IDFUNC"};

/*  Strings para nomes dos tipos de variaveis/funções  */

char *nometipvar[6] = {"NAOVAR",
    "INTEIRO", "LOGICO", "REAL", "CARACTERE", "FUNCVOID"
};

/* Strings para operadores de quadruplas */

char *nomeoperquad[27] = {"",
	"OR", "AND", "LT", "LE", "GT", "GE", "EQ", "NE", "MAIS",
	"MENOS", "MULT", "DIV", "RESTO", "MENUN", "NOT", "ATRIB",
	"OPENMOD", "NOP", "JUMP", "JF", "PARAM", "OPCALL", "RET", "READ", "WRITE", "NONE"
};

/*
	Strings para tipos de operandos de quadruplas
 */

char *nometipoopndquad[10] = {"IDLE",
	"VAR", "INT", "REAL", "CARAC", "LOGIC", "CADEIA", "ROTULO", "MODULO", "FUNCAO"
};

/* Declaracoes para a estrutura do codigo intermediario */

typedef union atribopnd atribopnd;
typedef struct operando operando;
typedef struct celquad celquad;
typedef celquad *quadrupla;
typedef struct celmodhead celmodhead;
typedef celmodhead *modhead;

typedef struct celsimb celsimb;
typedef celsimb *simbolo;
typedef struct lista lista;
typedef lista *parametros;

union atribopnd {
	simbolo simb; int valint; float valfloat;
	char *valchar; char vallogic; char *valcad;
	quadrupla rotulo; modhead modulo;
};

struct operando {
	int tipo; atribopnd atr;
  int isTemp;
};

struct celquad {
	int num, oper, geradaTemp; operando opnd1, opnd2, result;
	quadrupla prox;
};

struct celmodhead {
	simbolo modname; modhead prox;
	quadrupla listquad;
};

/*    Declaracoes para a tabela de simbolos     */

struct lista {
    lista *prox;
    int tipo;
};

struct celsimb {
    char *cadeia;
    char *escopo;
    int tid, tvar, ndims, dims[MAXDIMS+1];
    char inic, ref, array;
    simbolo prox;
    parametros param;
    modhead fhead;
};

/*  Variaveis globais para a tabela de simbolos e analise semantica */

simbolo tabsimb[NCLASSHASH];
simbolo simb;
int tipocorrente;
char *escopocorrente;

/*
    Prototipos das funcoes para a tabela de simbolos
        e analise semantica
 */
int tab = 0;
void InicTabSimb (void);
void SetarEscopo(char *escopo);
void adicionaParametro();
void TipoFuncaoInadequado(char *s);
void ImprimeTabSimb (void);
simbolo InsereSimb (char *, int, int);
int hash (char *);
simbolo ProcuraSimb (char *, char *);
void DeclaracaoRepetida (char *);
void TipoInadequado (char *);
void NaoDeclarado (char *);
void VerificaInicRef (void);
void Incompatibilidade (char *);
void Esperado (char *);
void NaoEsperado (char *);
void TipoErradoDeArgumentos();
void QuantidadeErradaDeArgumentos();
void RecursividadeNaoAdimitida();

/* Variaveis globais para o codigo intermediario */

quadrupla quadcorrente, quadaux, quadaux2, quadaux3;
modhead codintermed, modcorrente;
int oper, numquadcorrente;
operando opnd1, opnd2, result, opndaux;
int numtemp;
const operando opndidle = {IDLEOPND, 0};

/* Prototipos das funcoes para o codigo intermediario */

void InicCodIntermed (void);
void InicCodIntermMod (simbolo);
void ImprimeQuadruplas (void);
quadrupla GeraQuadrupla (int, operando, operando, operando, int);
simbolo NovaTemp (int);
void RenumQuadruplas (quadrupla, quadrupla);

/* Declaracoes para atributos das expressoes e variaveis */

typedef struct infoexpressao infoexpressao;
struct infoexpressao {
	int tipo;
	operando opnd;
};

typedef struct infovariavel infovariavel;
struct infovariavel {
	simbolo simb;
	operando opnd;
};

%}
%union {
	char string[50];
	int atr, valor;
	float valreal;
	char carac;
  simbolo simb;
  infoexpressao infoexpr;
	infovariavel infovar;
  int tipoexpr;
  int nsubscr;
  int returnedTypes[5];
  int returnedType;
  lista *paramQueSobe;
  quadrupla quad1, quad2;
}

%type       <infovar>        Variable
%type       <infoexpr>      Expression  AuxExpr1  AuxExpr2
                            AuxExpr3   AuxExpr4   Term   Factor FuncCall
%type       <nsubscr>       Subscripts SubscrList



%type       <returnedTypes> ModBody StatList CompStat Stats
%type       <returnedType>  Statement ReturnStat ModHeader WhileStat IfStat RepeatStat ForStat  ElseStat

%type       <paramQueSobe> Arguments ExprList

%type       <nsubscr>           ReadList WriteList

%token		<string> ID
%token 		<string> CHARCT
%token 		<string> STRING
%token      <valor> INTCT
%token      <valreal> FLOATCT

%token 		OR
%token 		AND
%token 		NOT

%token 		<atr> RELOP
%token 		<atr> ADOP
%token 		<atr> MULTOP

%token      NEG

%token 		OPPAR
%token 		CLPAR
%token 		OPBRAK
%token 		CLBRAK
%token 		OPBRACE
%token 		CLBRACE
%token 		OPTRIP
%token 		CLTRIP

%token 		COMMA
%token      SCOLON
%token 		ASSIGN
%token      CHAR
%token      DO
%token      ELSE
%token      FALSE
%token      FLOAT
%token      IF
%token      INT
%token      LOGIC
%token      READ
%token      STATEMENTS
%token      THEN
%token      TRUE
%token      VAR
%token      WHILE
%token      WRITE
%token      INVAL

%token      VOID
%token      FOR
%token      CALL
%token      COLON
%token      MAIN
%token      REPEAT
%token      RETURN


%%

Prog            :   {
                      InicTabSimb ();
                      InicCodIntermed();
                      numtemp = 0;
                    }  ID  OPTRIP  {
                        printf ("%s {{{\n", $2);
                        SetarEscopo("GLOBAL");
                        InsereSimb ($2, IDPROG, NAOVAR);

                        simb = InsereSimb($2, IDPROG, NAOVAR);
                        InicCodIntermMod(simb);
                        opnd1.tipo = MODOPND;
                        opnd1.atr.modulo = modcorrente;
                        opnd1.isTemp = 0;
                        GeraQuadrupla(OPENMOD, opnd1, opndidle, opndidle, 0);
                    }
                    Decls  {SetarEscopo("GLOBAL");} ModList MainMod CLTRIP  {
                        printf ("}}}\n");

                        VerificaInicRef ();
                        ImprimeTabSimb ();
                        ImprimeQuadruplas();
                    }

Decls           :
                |   VAR  OPBRACE  {printf ("var {\n"); tab++;}  DeclList
                    CLBRACE  {tab--;printf ("}\n");}

DeclList		:	 Declaration  |  DeclList  Declaration
                ;

Declaration     :    {tabular();} Type  ElemList  SCOLON  {printf (";\n");}
                ;

Type            :   INT  {printf ("int "); tipocorrente = INTEIRO;}
                |   FLOAT  {printf ("float "); tipocorrente = REAL;}
                |   CHAR  {printf ("char "); tipocorrente = CARACTERE;}
                |   LOGIC  {printf ("logic "); tipocorrente = LOGICO;}
                |   VOID  {printf ("void "); tipocorrente = FUNCVOID;}
                ;

ElemList        :   Elem  |  ElemList  COMMA  {printf (", ");}  Elem
                ;

Elem        	:	ID {
                        printf ("%s", $1);
                        if (ProcuraSimb ($1, escopocorrente) != NULL) {
                            DeclaracaoRepetida ($1);
                        }
                        else{

                            simb = InsereSimb ($1, IDVAR, tipocorrente);
                            simb->array = FALSO; simb->ndims = 0;
                        }
                    } Dims
                ;

Dims            :
                |   OPBRAK  {printf ("[ ");}  DimList
                    CLBRAK  {printf ("] "); simb->array = VERDADE;}
                ;

DimList         :   INTCT   {
                            printf ("%d ", $1);
                            if ($1 <= 0) Esperado ("Valor inteiro positivo");
                            simb->ndims = 1;
                            simb->dims[1] = $1;
                        }
                |   INTCT  COMMA  INTCT  {
                            printf ("%d , %d ", $1, $3);
                            if ($1 <= 0 || $3 <= 0) Esperado ("Valor inteiro positivo");
                            simb->ndims = 2;
                            simb->dims[1] = $1;
                            simb->dims[2] = $3;
                        }

                |   INTCT  COMMA  INTCT  COMMA  INTCT
                    { printf ("%d , %d , %d ", $1, $3, $5);
                      if ($1 <= 0 || $3 <= 0 || $5 <= 0) Esperado ("Valor inteiro positivo");
                      simb->ndims = 3;
                      simb->dims[1] = $1; simb->dims[2] = $3; simb->dims[3] = $5;    }
                ;

ModList         :
                |   ModList  Module
                ;

Module          :   ModHeader ModBody {
                    if ($1 == INTEIRO)
                    {
                        if($2[0] == 1 || $2[REAL] == 1 || $2[LOGICO] == 1)
                        {
                            Incompatibilidade ("Return indevido no escopo da funcao.");
                        }
                    }
                    if ($1 == REAL)
                    {
                        if($2[0] == 1 || $2[LOGICO] == 1)
                        {
                            Incompatibilidade ("Return indevido no escopo da funcao.");
                        }
                    }
                    if ($1 == CARACTERE)
                    {
                        if($2[0] == 1 || $2[REAL] == 1 || $2[LOGICO] == 1)
                        {
                            Incompatibilidade ("Return indevido no escopo da funcao.");
                        }
                    }
                    if ($1 == LOGICO)
                    {
                        if($2[0] == 1 || $2[REAL] == 1 || $2[INTEIRO] == 1 || $2[CARACTERE] == 1)
                        {
                            Incompatibilidade ("Return indevido no escopo da funcao.");
                        }
                    }
                    if ($1 == FUNCVOID)
                    {
                        if($2[LOGICO] == 1 || $2[REAL] == 1 || $2[INTEIRO] == 1 || $2[CARACTERE] == 1)
                        {
                            Incompatibilidade ("Return indevido no escopo da funcao.");
                        }
                        GeraQuadrupla(OPRET, opndidle, opndidle, opndidle, 0);
                    }

                    SetarEscopo("GLOBAL");
                }
                ;

ModHeader       :   Type ID OPPAR  CLPAR {
                        simb = ProcuraSimb ($2, "GLOBAL");
                        if(simb != NULL) DeclaracaoRepetida ($2);
                        else { InsereSimb($2, IDFUNC, tipocorrente); }

                        printf ("%s ()\n", $2);
                        $$ = tipocorrente;
                        SetarEscopo($2);

                        simb = ProcuraSimb ($2, "GLOBAL");
                        InicCodIntermMod(simb);
                        }
                |   Type ID OPPAR {
                        simb = ProcuraSimb ($2, "GLOBAL");
                        if(simb != NULL) DeclaracaoRepetida ($2);
                        else { InsereSimb($2, IDFUNC, tipocorrente); }

                        printf ("%s (", $2);
                        $$ = tipocorrente;
                        SetarEscopo($2);

                        simb = ProcuraSimb ($2, "GLOBAL");
                        InicCodIntermMod(simb);

                        } ParamList  CLPAR {printf (")\n"); }
                ;

ParamList       :   Parameter
                |   ParamList  COMMA {printf (", ");} Parameter
                ;

Parameter       :   Type  ID {
                        adicionaParametro();
                        simb = ProcuraSimb ($2, escopocorrente);
                        if (simb != NULL) DeclaracaoRepetida ($2);

                        simb = InsereSimb ($2, IDVAR, tipocorrente);
                        simb->array = FALSO; simb->ndims = 0;

                        printf ("%s ", $2);}
                ;


ModBody         :   Decls  Stats {$$[0] = $2[0]; $$[1] = $2[1]; $$[2] = $2[2]; $$[3] = $2[3]; $$[4] = $2[4];}
                ;

MainMod         :   MAIN {
                      printf("main\n");

                      SetarEscopo("MAIN");

                      simb = InsereSimb("MAIN", "GLOBAL", NAOVAR);
                      InicCodIntermMod(simb);

                    } ModBody {
                      SetarEscopo("GLOBAL");
                    }
                ;

Stats           :   STATEMENTS  {printf ("statements ");tab++;}  CompStat {tab--; $$[0] = $3[0]; $$[1] = $3[1]; $$[2] = $3[2]; $$[3] = $3[3]; $$[4] = $3[4];}
                ;


CompStat        :   OPBRACE  {tab--;tabular();tab++;printf ("{\n");}  StatList  CLBRACE
                    {tab--;tabular ();tab++; printf ("}\n"); $$[0] = $3[0]; $$[1] = $3[1]; $$[2] = $3[2]; $$[3] = $3[3]; $$[4] = $3[4];}

StatList        :
                {
                    int i =0;
                    for (i=0; i<5; i++) {
                        $$[i] = 0;
                    }
                }
                |   StatList  Statement {if ($2 != -1) {
                if ($2 < 5) {$$[$2] = 1;}
                else {
                  int i=0;
                  int gambi = $2-5;
                  for (i=0; i<5; i++) {
                    $$[i] = (gambi%10 == 1 || $1[i]==1) ? 1:0;
                    gambi = gambi/10;
                  }
                }
                } else
                {
                    int i =0;
                    for (i=0; i<5; i++) {
                        $$[i] = 0;
                }
                }

                }
                ;

Statement       :   CompStat {$$ = (5 + ($1[0]==1 ?1:0) + 10*($1[1]==1 ?1:0)+ 100*($1[2]==1 ?1:0)+1000*($1[3]==1 ?1:0)+10000*($1[4]==1 ?1:0));}
                |   IfStat  {$$ = $1;}
                |   WhileStat  {$$ = $1;}
                |   RepeatStat  {$$ = $1;}
                |   ForStat  {$$ = $1;}
                |   ReadStat  {$$ = -1;}
                |   WriteStat  {$$ = -1;}
                |   AssignStat  {$$ = -1;}
                |   CallStat  {$$ = -1;}
                |   ReturnStat  {$$ = $1;}
                |   SCOLON  {$$ = -1;}
                ;

IfStat          :  {tabular ();} IF  {printf ("if ");} Expression {
                        if($4.tipo != LOGICO){
                            Esperado("Expressao logica no cabecalho do IF");
                        }
                    }  THEN {
                        printf ("then \n");
                        tab++;

                        operando op;
                        op.tipo = ROTOPND;
                        op.atr.rotulo = quadaux;

                        operando condition = $4.opnd;
                        $<quad1>$ = GeraQuadrupla(OPJF, condition, opndidle, op, 0);
                    } Statement {
                        ($<quad1>7->result).atr.rotulo = GeraQuadrupla(OPNONE, opndidle, opndidle, opndidle, 0);

                        operando op;
                        op.tipo = ROTOPND;
                        op.atr.rotulo = quadaux;
                        $<quad2>$ = GeraQuadrupla(OPJUMP, $4.opnd, opndidle, op, 0);
                    } ElseStat {
                        int bosta[5] ={0};
                        if ($8 < 5) {
                            if ($8 >= 0) {
                                bosta[$8] = 1;
                            }
                        } else {
                            int i=0;
                            int gambi = $8-5;
                            for (i=0; i<5; i++) {
                                bosta[i] = (gambi%10 == 1) ? 1:0;
                                gambi = gambi/10;
                            }
                        }

                        if ($10 < 5) {
                            if ($10 >= 0) {
                                bosta[$10] = 1;
                            }
                        } else {
                            int i=0;
                            int gambi = $10-5;
                            for (i=0; i<5; i++) {
                                bosta[i] = (gambi%10 == 1 || bosta[i]==1) ? 1:0;
                                gambi = gambi/10;
                            }
                        }
                      $$ = (5 + (bosta[0]==1 ?1:0) + 10*(bosta[1]==1 ?1:0)+ 100*(bosta[2]==1 ?1:0)+1000*(bosta[3]==1 ?1:0)+10000*(bosta[4]==1 ?1:0));
                      ($<quad2>9->result).atr.rotulo = GeraQuadrupla(OPNONE, opndidle, opndidle, opndidle, 0);
                    }
                ;


ElseStat        :   { tab--; $$ = -1;}
                |   ELSE {tab--; tabular();printf ("else\n ");tab++;} Statement {tab--; $$ = $3;}
                ;



WhileStat       :   {tabular ();} WHILE  {printf ("while ");} Expression {
                        if($4.tipo != LOGICO){
                            Esperado("Expressao logica no cabecalho do WHILE");
                        }
                    } DO {
                        printf ("do \n");
                        tab++;
                        $<quad1>$ = GeraQuadrupla(OPNONE, opndidle, opndidle, opndidle, 0);

                        operando opaux;
                        opaux.tipo = ROTOPND;
                        opaux.atr.rotulo = quadaux;
                        $<quad2>$ = GeraQuadrupla(OPJF, $4.opnd, opndidle, opaux, 0);
                    }  Statement {
                        tab--;
                        $$ = $8;

                        operando op;
                        op.tipo = ROTOPND;
                        op.atr.rotulo = $<quad1>7;
                        GeraQuadrupla(OPJUMP, $4.opnd, opndidle, op, 0);

                        ($<quad2>7->result).atr.rotulo = GeraQuadrupla(OPNONE, opndidle, opndidle, opndidle, 0);
                      }
                ;


RepeatStat      :   {tabular ();} REPEAT  {
                        printf ("repeat \n");
                        tab++;
                        $<quad1>$ = GeraQuadrupla(OPNONE, opndidle, opndidle, opndidle, 0);
                      }
                      Statement WHILE  {tab--;tabular();printf ("while "); $$ = $4;} Expression{
                        if($7.tipo != LOGICO){
                            Esperado("Expressao logica no enncerramento do REPEAT");
                        }

                        operando op;
                        op.tipo = ROTOPND;
                        op.atr.rotulo = $<quad1>3;
                        GeraQuadrupla(OPJUMP, $7.opnd, opndidle, op, 0);

                    }  SCOLON {printf (";\n");}
                ;

ForStat         :   {tabular ();}
                    FOR  {printf ("for ");}
                    Variable {
                            if ($4.simb == NULL) NaoDeclarado ("Variavel de controle do For");
                            else if($4.simb->array == VERDADE || ($4.simb->tvar != CARACTERE && $4.simb->tvar != INTEIRO)) {
                                Esperado("Variavel de controle do FOR escalar inteira ou escalar caractere");
                            }
                        }
                    OPPAR  {printf ("( ");}
                    AuxExpr4 {
                            if($8.tipo != INTEIRO && $8.tipo != CARACTERE){
                                Esperado("Primeira expressao do FOR inteira ou caractere");
                            }
                            operando resultOp;
                            resultOp.isTemp = 0;
                            resultOp.tipo = VAROPND;
                            resultOp.atr.simb = $4.simb;
                            GeraQuadrupla(OPATRIB, $8.opnd, opndidle, resultOp, 0);
                        }
                    COLON  {printf (": ");}
                    Expression {
                            if($12.tipo != LOGICO){
                                Esperado("Segunda expressao do FOR logica");
                            }
                            operando opaux;
                            opaux.tipo = ROTOPND;
                            opaux.atr.rotulo = quadaux;
                            $<quad2>$ = GeraQuadrupla(OPJF, $12.opnd, opndidle, opaux, 0);

                        }
                        COLON {printf (": ");}   AuxExpr4{
                        if($16.tipo != INTEIRO && $16.tipo != CARACTERE){
                            Esperado("Terceira expressao do FOR inteira ou caractere");
                            }
                        }   CLPAR {printf (")\n"); tab++; }  Statement {
                            tab--;
                            $$ = $20;

                            operando op;
                            op.tipo = ROTOPND;
                            op.atr.rotulo = $<quad2>13;
                            GeraQuadrupla(OPJUMP, $12.opnd, opndidle, op, 0);

                            ($<quad2>13->result).atr.rotulo = GeraQuadrupla(OPNONE, opndidle, opndidle, opndidle, 0);
                          }
                ;

ReadStat        :   READ {tabular(); printf ("read (");} OPPAR  ReadList  CLPAR  SCOLON {
                      printf (");\n");
                      operando op;
                      op.tipo = INTOPND;
                      op.atr.valint = $4;
                      op.isTemp = 0;
                      GeraQuadrupla(OPREAD, op, opndidle, opndidle,0);
                    }
                ;

ReadList        :   Variable {$$ = 1;}
                |   ReadList  COMMA {printf (",");} Variable {$$ = $1 + 1;}
                ;

WriteStat       :   WRITE  OPPAR  { tabular ();printf ("write ( ");} WriteList  CLPAR  SCOLON {
                      printf (");\n");
                      operando op;
                      op.tipo = INTOPND;
                      op.atr.valint = $4;
                      op.isTemp = 0;
                      GeraQuadrupla(OPWRITE, op, opndidle, opndidle,0);
                    }
                ;

WriteList       :   WriteElem {$$ = 1;}  |  WriteList  COMMA {printf (", ");} WriteElem {$$ = $1 + 1;}
                ;

WriteElem       :   STRING {printf ("%s", $1);} |  Expression
                ;

CallStat        :   CALL  ID  OPPAR {
                        tabular();
                        printf("call %s(",$2);
                        simb = ProcuraSimb ($2, "GLOBAL");
                        if (simb == NULL) NaoDeclarado ($2);
                        else if (simb->tid != IDFUNC)   TipoInadequado ($2);
                        else if (simb->tvar != FUNCVOID){
                            TipoFuncaoInadequado ($2);
                        }
                    } Arguments  CLPAR  SCOLON {
                        printf (");\n");
                        simb = ProcuraSimb ($2, "GLOBAL");
                        lista* aux = $5;
                        int deuRuim = 0;
                        int tamanhoDoSubido = 0;

                        if (simb == NULL) {}
                        else if (simb->tid != IDFUNC)   {}
                        else if (simb->tvar != FUNCVOID){}
                        else {

                            while (aux != NULL){
                                tamanhoDoSubido ++;
                                aux = aux->prox;
                            }
                            if(tamanhoDoSubido != simb->param->tipo){
                                QuantidadeErradaDeArgumentos();
                            }
                            else
                            {
                                aux = $5;
                                lista* aux2 = simb->param->prox;
                                int i = 0;
                                for(; i < tamanhoDoSubido; i++){
                                    if( (aux2->tipo == INTEIRO && (aux->tipo != INTEIRO && aux->tipo != CARACTERE))  ||
                                        (aux2->tipo == CARACTERE && (aux->tipo != INTEIRO && aux->tipo != CARACTERE)) ||
                                        (aux2->tipo == REAL && (aux->tipo != REAL && aux->tipo != INTEIRO && aux->tipo != CARACTERE)) ||
                                        (aux2->tipo == LOGICO && (aux->tipo != LOGICO)) ){
                                        TipoErradoDeArgumentos (aux2->tipo, i + 1);
                                    }
                                    aux = aux->prox;
                                    aux2 = aux2->prox;
                                }
                            }
                        }

                        infoexpressao thisAux;
                        thisAux.opnd.tipo = FUNCAO;
                        thisAux.opnd.atr.simb = simb;
                        thisAux.opnd.atr.simb->cadeia = $2;

                        operando op;
                        op.tipo = FUNCAO;
                        op.atr.simb = simb;
                        op.isTemp = 0;

                        operando op2;
                        op2.tipo = INTOPND;
                        op2.atr.valint = tamanhoDoSubido;
                        op2.isTemp = 0;

                        operando result;
                        result.tipo = VAROPND;
                        result.atr.simb = NovaTemp(FUNCVOID);
                        result.isTemp = 1;
                        GeraQuadrupla(OPCALL, op, op2, result, 1);

                    }
                ;

Arguments       :  {$$ = NULL;}
                |  ExprList {$$ = $1;}
                ;

ReturnStat      :   RETURN SCOLON {
                      tabular();
                      printf ("return ;\n");
                      $$ = 0;
                      GeraQuadrupla(OPRET, opndidle, opndidle, opndidle, 0);
                    }
                |   RETURN {tabular();printf ("return ");} Expression SCOLON {
                      $$ = $3.tipo;
                      printf (";\n");
                    }
                ;

AssignStat      :   {tabular ();} Variable
                    { if  ($2.simb != NULL) $2.simb->inic = $2.simb->ref = VERDADE;}
                    ASSIGN  {printf (":= ");}  Expression  SCOLON
                    {
                        printf (";\n");
                        if ($2.simb != NULL) {
                            if ((($2.simb->tvar == INTEIRO || $2.simb->tvar == CARACTERE) &&
                                ($6.tipo == REAL || $6.tipo == LOGICO)) ||
                                ($2.simb->tvar == REAL && $6.tipo == LOGICO) ||
                                ($2.simb->tvar == LOGICO && $6.tipo != LOGICO))
                                Incompatibilidade ("Lado direito de comando de atribuicao improprio");
                            operando resultOp;
                            resultOp.isTemp = 0;
                            resultOp.tipo = VAROPND;
                            resultOp.atr.simb = $2.simb;
                            GeraQuadrupla(OPATRIB, $6.opnd, opndidle, resultOp, 0);
                        }
                    }
                ;


ExprList		:	Expression {
                $$ = (lista*) malloc (sizeof(lista));
                $$->tipo = $1.tipo; $$->prox = NULL;
                GeraQuadrupla(PARAM, $1.opnd, opndidle, opndidle, 0);
              }
				|	ExprList  COMMA {printf (", ");}  Expression {
                        $$ = $1;
                        lista *p = $$;
                        while (p->prox != NULL) {
                            p = p->prox;
                        }
                        p->prox = (lista*) malloc (sizeof(lista));
                        p->prox->tipo = $4.tipo;
                        p->prox->prox = NULL;
                        GeraQuadrupla(OPATRIB, $4.opnd, opndidle, opndidle, 0);
                    }
				;

Expression      :   AuxExpr1 { $$ = $1;}
                |  Expression  OR  {printf ("|| ");}  AuxExpr1  {
                        if ($1.tipo != LOGICO || $4.tipo != LOGICO)
                            Incompatibilidade ("Operando improprio para operador or");
                        $$.tipo = LOGICO;

                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp($$.tipo);
                        $$.opnd.isTemp = 1;
                        GeraQuadrupla(OPOR, $1.opnd, $4.opnd, $$.opnd,1);
                    }
                ;
AuxExpr1        :   AuxExpr2 { $$ = $1;}
                |  AuxExpr1  AND  {printf ("&& ");}  AuxExpr2  {
                        if ($1.tipo != LOGICO || $4.tipo != LOGICO)
                            Incompatibilidade ("Operando improprio para operador and");
                        $$.tipo = LOGICO;

                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp($$.tipo);
                        $$.opnd.isTemp = 1;
                        GeraQuadrupla(OPAND, $1.opnd, $4.opnd, $$.opnd,1);
                    }
                ;
AuxExpr2        :   AuxExpr3 { $$ = $1;}
                |  NOT  {printf ("! ");}  AuxExpr3  {
                        if ($3.tipo != LOGICO)
                            Incompatibilidade ("Operando improprio para operador not");
                        $$.tipo = LOGICO;

                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp($$.tipo);
                        $$.opnd.isTemp = 1;
                        GeraQuadrupla(OPNOT, $3.opnd, opndidle, $$.opnd,1);
                    }
                ;

AuxExpr3        :   AuxExpr4 { $$ = $1;}
                |   AuxExpr4  RELOP  {
                        switch ($2) {
                            case LT: printf ("< "); break;
                            case LE: printf ("<= "); break;
                            case EQ: printf ("= "); break;
                            case NE: printf ("!= "); break;
                            case GT: printf ("> "); break;
                            case GE: printf (">= "); break;
                        }
                    }  AuxExpr4  {
                        switch ($2) {
                            case LT: case LE: case GT: case GE:
                                if ($1.tipo != INTEIRO && $1.tipo != REAL && $1.tipo != CARACTERE || $4.tipo != INTEIRO && $4.tipo != REAL && $4.tipo != CARACTERE)
                                    Incompatibilidade   ("Operando improprio para operador relacional");
                                break;
                            case EQ: case NE:
                                if (($1.tipo == LOGICO || $4.tipo == LOGICO) && $1.tipo != $4.tipo)
                                    Incompatibilidade ("Operando improprio para operador relacional");
                                break;
                        }
                        $$.tipo = LOGICO;

                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp($$.tipo);
                        $$.opnd.isTemp = 1;
                        int operation;
                        switch ($2) {
                            case LT: operation = OPLT; break;
                            case LE: operation = OPLE; break;
                            case EQ: operation = OPEQ; break;
                            case NE: operation = OPNE; break;
                            case GT: operation = OPGT; break;
                            case GE: operation = OPGE; break;
                        }
                        GeraQuadrupla(operation, $1.opnd, $4.opnd, $$.opnd, 1);
                    }
                ;

AuxExpr4        :   Term { $$ = $1;}
                |   AuxExpr4  ADOP  {
                        switch ($2) {
                            case PLUS: printf ("+ "); break;
                            case MINUS: printf ("- "); break;
                        }
                    }  Term  {
                        if ($1.tipo != INTEIRO && $1.tipo != REAL && $1.tipo != CARACTERE || $4.tipo != INTEIRO && $4.tipo != REAL && $4.tipo != CARACTERE)
                            Incompatibilidade ("Operando improprio para operador aritmetico");
                        if ($1.tipo == REAL || $4.tipo == REAL) {
                          $$.tipo = REAL;
                        }
                        else {
                          $$.tipo = INTEIRO;
                        }

                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp($$.tipo);
                        $$.opnd.isTemp = 1;
                        GeraQuadrupla(OPMAIS, $1.opnd, $4.opnd, $$.opnd, 1);
                    }
                ;

Term            :   Factor { $$ = $1; }
                |   Term  MULTOP  {
                        switch ($2) {
                            case MULT:
                                printf ("* ");
                                break;
                            case DIV:
                                printf ("/ ");
                                break;
                            case MOD:
                                printf ("%% ");
                                break;
                        }
                    }  Factor   {
                        switch ($2) {
                            case MULT: case DIV:
                                if ($1.tipo != INTEIRO && $1.tipo != REAL && $1.tipo != CARACTERE
                                    || $4.tipo != INTEIRO && $4.tipo != REAL && $4.tipo != CARACTERE)
                                    Incompatibilidade ("Operando improprio para operador aritmetico");
                                if ($1.tipo == REAL || $4.tipo == REAL) $$.tipo = REAL;
                                else $$.tipo = INTEIRO;
                                $$.opnd.tipo = VAROPND;
                                $$.opnd.atr.simb = NovaTemp($$.tipo);
                                $$.opnd.isTemp = 1;
                                if ($2 == MULT)
                                    GeraQuadrupla(OPMULTIP, $1.opnd, $4.opnd, $$.opnd, 1);
                                else
                                    GeraQuadrupla(OPDIV, $1.opnd, $4.opnd, $$.opnd, 1);
                                break;
                            case MOD:
                                if ($1.tipo != INTEIRO && $1.tipo != CARACTERE
                                    ||  $4.tipo != INTEIRO && $4.tipo != CARACTERE)
                                    Incompatibilidade ("Operando improprio para operador resto");
                                $$.tipo = INTEIRO;
                                $$.opnd.tipo = VAROPND;
                                $$.opnd.atr.simb = NovaTemp($$.tipo);
                                $$.opnd.isTemp = 1;
                                GeraQuadrupla(OPRESTO, $1.opnd, $4.opnd, $$.opnd, 1);
                                break;
                        }
                    }
                ;

Factor          :   Variable  {
                        if  ($1.simb != NULL) {
                            $1.simb->ref  =  VERDADE;
                            $$.tipo = $1.simb->tvar;
                            $$.opnd = $1.opnd;
                        }
                    }
                |   INTCT  {
                        printf ("%d ", $1);
                        $$.tipo = INTEIRO;
                        $$.opnd.tipo = INTOPND;
                        $$.opnd.atr.valint = $1;
                    }
                |   FLOATCT  {
                        printf ("%g ", $1);
                        $$.tipo = REAL;
                        $$.opnd.tipo = REALOPND;
                        $$.opnd.atr.valfloat = $1;
                    }
                |   CHARCT  {
                        printf ("\'%s\' ", $1);
                        $$.tipo = CARACTERE;
                        $$.opnd.tipo = CHAROPND;
                        $$.opnd.atr.valchar = $1;
                    }
                |   TRUE  {
                        printf ("true ");
                        $$.tipo = LOGICO;
                        $$.opnd.tipo = LOGICOPND;
                        $$.opnd.atr.vallogic = 1;
                    }
                |   FALSE  {
                        printf ("false ");
                        $$.tipo = LOGICO;
                        $$.opnd.tipo = LOGICOPND;
                        $$.opnd.atr.vallogic = 0;
                    }
                |   NEG  {printf ("~ ");}  Factor  {
                        if ($3.tipo != INTEIRO && $3.tipo != REAL && $3.tipo != CARACTERE)
                            Incompatibilidade  ("Operando improprio para menos unario");
                        if ($3.tipo == REAL) $$.tipo = REAL;
                        else $$.tipo = INTEIRO;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp($$.tipo);
                        $$.opnd.isTemp = 1;
                        GeraQuadrupla(OPMENUN, $3.opnd, opndidle, $$.opnd, 1);
                    }
                |   OPPAR  {
                        printf ("( ");
                  }  Expression
                    CLPAR  {
                      printf (") ");
                      $$ = $3;
                      $$.tipo = $3.tipo;
                      $$.opnd = $3.opnd;
                    }
                |   FuncCall {
                            // $$ = $1;
                            $$.tipo = NAOVAR;
                            $$.opnd.tipo = FUNCAO;
                            // $$.opnd.atr.simb->cadeia = $$.opn;
                            $$.opnd.isTemp = 0;
                            // printf("********************** tipo=%s **********************", $1.opnd.atr.simb->cadeia);
                    }
                ;

Variable        :   ID  {
                        printf ("%s ", $1);
                        simb = ProcuraSimb ($1, escopocorrente);
                        if( simb == NULL) {simb = ProcuraSimb ($1, "GLOBAL");}
                        if (simb == NULL) NaoDeclarado ($1);
                        else if (simb->tid != IDVAR) TipoInadequado ($1);
                        $<simb>$ = simb;
                    }   Subscripts {
                                    $$.simb = $<simb>2;
                                    if ($$.simb != NULL) {
                                        if ($$.simb->array == FALSO && $3 > 0)
                                            NaoEsperado ("Subscrito\(s)");
                                        else if ($$.simb->array == VERDADE && $3 == 0)
                                            Esperado ("Subscrito\(s)");
                                        else if ($$.simb->ndims != $3)
                                            Incompatibilidade ("Numero de subscritos incompativel com declaracao");
                                        $$.opnd.tipo = VAROPND;

                                        $$.opnd.atr.simb = $$.simb;
                                        if ($3 == 0) {
                                          $$.opnd.atr.simb->array = FALSO;
                                        } else {
                                          $$.opnd.atr.simb->array = VERDADE;
                                        }
                                    }
                        }
                ;

Subscripts      :   {$$ = 0;}
                |   OPBRAK  {printf ("[ ");}  SubscrList
                    CLBRAK  {printf ("] "); $$ = $3; }
                ;
SubscrList      :   AuxExpr4
                    {
                        $$ = 1;
                        if ($1.tipo != INTEIRO && $1.tipo != CARACTERE)
                        Incompatibilidade ("Tipo inadequado para subscrito");
                    }
                |   TwoSubscr {$$ = 2;}
                |   ThreeSubscr {$$ =3;}
                ;

TwoSubscr       :   AuxExpr4  COMMA  {printf (", ");}  AuxExpr4 { if ($1.tipo != INTEIRO && $1.tipo != CARACTERE ||
                                                                    $4.tipo != INTEIRO && $4.tipo != CARACTERE)
                                                                    Incompatibilidade ("Tipo inadequado para subscrito");   }

                ;

ThreeSubscr     :       TwoSubscr  COMMA {printf (", ");} AuxExpr4 { if ($4.tipo != INTEIRO && $4.tipo != CARACTERE)
                        Incompatibilidade ("Tipo inadequado para subscrito"); }

                ;

FuncCall        :       ID  {
                            simb = ProcuraSimb ($1, "GLOBAL");
                            if (simb == NULL) NaoDeclarado ($1);
                            else if (simb->tid != IDFUNC)   TipoInadequado ($1);
                            else if (simb->tvar == FUNCVOID) TipoFuncaoInadequado ($1);
                            else if ( strcmp(simb->cadeia, escopocorrente) == 0) RecursividadeNaoAdimitida();
                            else{
                                $$.tipo = simb->tvar;
                                $$.opnd.tipo = FUNCAO;
                                $$.opnd.atr.simb = simb;
                                $$.opnd.atr.simb->cadeia = $1;
                            }
                            printf("%s", $1);
                          }
                        OPPAR {printf ("(");} Arguments  CLPAR
                        {
                        printf (")");
                        simb = ProcuraSimb($1, "GLOBAL");
                        if (simb == NULL) NaoDeclarado ($1);
                        else if (simb->tid != IDFUNC)  {}
                        else if (simb->tvar == FUNCVOID) {}
                        else if ( strcmp(simb->cadeia, escopocorrente) == 0) {}
                        else{
                            lista *aux = $5;
                            int deuRuim = 0;
                            int tamanhoDoSubido = 0;

                            $$.opnd.tipo = FUNCAO;
                            $$.opnd.atr.simb = simb;
                            $$.opnd.atr.simb->cadeia = $1;
                            operando op;
                            op.tipo = FUNCAO;
                            op.atr.simb = simb;
                            op.isTemp = 0;

                            operando op2;
                            op2.tipo = INTOPND;
                            op2.atr.valint = simb->ndims;
                            op2.isTemp = 0;

                            operando result;
                            result.tipo = VAROPND;
                            result.atr.simb = NovaTemp($$.tipo);
                            result.isTemp = 1;
                            GeraQuadrupla(OPCALL, op, op2, result, 1);

                            while (aux != NULL) {
                                tamanhoDoSubido++;
                                aux = aux->prox;
                            }
                            if(tamanhoDoSubido != simb->param->tipo) {
                                QuantidadeErradaDeArgumentos();
                            }
                            else {
                                aux = $5;
                                lista *queroMorrer = simb->param->prox;
                                int i=0;
                                for(; i<tamanhoDoSubido; i++) {
                                    if ((queroMorrer->tipo == INTEIRO && (aux->tipo != INTEIRO && aux->tipo != CARACTERE))  ||
                                        (queroMorrer->tipo == CARACTERE && (aux->tipo != INTEIRO && aux->tipo != CARACTERE)) ||
                                        (queroMorrer->tipo == REAL && (aux->tipo != REAL && aux->tipo != INTEIRO && aux->tipo != CARACTERE)) ||
                                        (queroMorrer->tipo == LOGICO && (aux->tipo != LOGICO))) {
                                        TipoErradoDeArgumentos(queroMorrer->tipo, i+1);
                                    }
                                    aux = aux->prox;
                                    queroMorrer = queroMorrer->prox;
                                }
                            }
                        }
                    }
                ;

%%
#include "lex.yy.c"


void InicCodIntermed (void) {
  codintermed = malloc(sizeof(celmodhead));
  modcorrente = codintermed;
  modcorrente->listquad = NULL;
  modcorrente->prox = NULL;
}

void InicCodIntermMod (simbolo simb) {
  modcorrente->prox = malloc(sizeof(celmodhead));
  modcorrente = modcorrente->prox;
  modcorrente->prox = NULL;
  modcorrente->modname = simb;
  modcorrente->listquad = malloc(sizeof(celquad));
  quadcorrente = modcorrente->listquad;
  quadcorrente->prox = NULL;
  numquadcorrente = 0;
  quadcorrente->num = numquadcorrente;
}

void ImprimeQuadruplas (void) {
  printf("\n\n*************** QUADRUPLAS ***************\n\n");

  quadrupla quad;
  modhead head;

  for(head = codintermed->prox; head != NULL; head = head->prox) {
    printf("Header:\n");
    /*
    struct celmodhead {
	    simbolo modname; modhead prox;
	     quadrupla listquad;
    };

    */
    printf("  Simbolo: %s, %s\n", head->modname->cadeia, head->modname->escopo);
    // char *cadeia;
    // char *escopo;
    // int tid, tvar, ndims, dims[MAXDIMS+1];
    // char inic, ref, array;
    // simbolo prox;
    // parametros param;

    printf("  Lista de quadruplas:\n");
    /*
    struct celquad {
    	int num, oper; operando opnd1, opnd2, result;
    	quadrupla prox;
    };
    */
    int line = 1;
    for (quad = head->listquad->prox; quad != NULL; quad = quad->prox) {

      printf("    %d) %s, ", line, nomeoperquad[quad->oper]);
      line++;

      if ((quad->opnd1).tipo == 0) {
        printf("(IDLE), ");
      } else {
        printf("(%s", nometipoopndquad[(quad->opnd1).tipo]);

        if ((quad->opnd1).isTemp == 1) {
          printf(", %s), ", (quad->opnd1).atr.simb->cadeia);
        }
        else if ((quad->opnd1).tipo == VAROPND) {
          printf(", %s), ", (quad->opnd1).atr.simb->cadeia);
        }
        else if ((quad->opnd1).tipo == INTOPND) {
          printf(", %d), ", (quad->opnd1).atr.valint);
        }
        else if ((quad->opnd1).tipo == REALOPND) {
          printf(", %f), ", (quad->opnd1).atr.valfloat);
        }
        else if ((quad->opnd1).tipo == CHAROPND) {
          printf(", %s), ", (quad->opnd1).atr.valchar);
        }
        else if ((quad->opnd1).tipo == LOGICOPND) {
          printf(", %d), ", (quad->opnd1).atr.vallogic);
        }
        else if ((quad->opnd1).tipo == FUNCAO) {
          printf(", %s), ", (quad->opnd1).atr.simb->cadeia);
        }
        else {
          printf("), ");
        }
      }

      if ((quad->opnd2).tipo == 0) {
        printf("(IDLE), ");
      }
      else {
        printf("(%s", nometipoopndquad[(quad->opnd2).tipo]);

        if ((quad->opnd1).isTemp == 1) {
          printf(", %s), ", (quad->opnd1).atr.simb->cadeia);
        }
        else if ((quad->opnd2).tipo == VAROPND) {
          printf(", %s), ", (quad->opnd2).atr.simb->cadeia);
        }
        else if ((quad->opnd2).tipo == INTOPND) {
          printf(", %d), ", (quad->opnd2).atr.valint);
        }
        else if ((quad->opnd2).tipo == REALOPND) {
          printf(", %f), ", (quad->opnd2).atr.valfloat);
        }
        else if ((quad->opnd2).tipo == CHAROPND) {
          printf(", %s), ", (quad->opnd2).atr.valchar);
        }
        else if ((quad->opnd2).tipo == LOGICOPND) {
          printf(", %d), ", (quad->opnd2).atr.vallogic);
        }
        else if ((quad->opnd2).tipo == FUNCAO) {
          // printf(", %s), ", (quad->opnd1).atr.simb->cadeia);
          printf("fudeu");
        }
        else {
          printf("), ");
        }
      }

      if ((quad->result).tipo == 0) {
        printf("(IDLE)\n");
      }
      else {
        printf("(%s", nometipoopndquad[(quad->result).tipo]);
        if ((quad->result).isTemp == 1) {
          printf(", %s)\n", (quad->result).atr.simb->cadeia);
        }
        else if ((quad->result).tipo == VAROPND) {
          printf(", %s)\n", (quad->result).atr.simb->cadeia);
        }
        else if ((quad->result).tipo == INTOPND) {
          printf(", %d)\n", (quad->result).atr.valint);
        }
        else if ((quad->result).tipo == REALOPND) {
          printf(", %f)\n", (quad->result).atr.valfloat);
        }
        else if ((quad->result).tipo == CHAROPND) {
          printf(", %s)\n", (quad->result).atr.valchar);
        }
        else if ((quad->result).tipo == LOGICOPND) {
          printf(", %d)\n", (quad->result).atr.vallogic);
        }
        else if ((quad->result).tipo == ROTOPND) {
          printf(", %d)\n", (quad->result).atr.rotulo->num);
        }
        else {
          printf(")\n");
        }
      }

     // printf("    num=%d, oper=%d, opnd1=%d, opnd2=%d, result=%d, temp = %d\n", quad->num, quad->oper, quad->opnd1, quad->opnd2, quad->result, quad->geradaTemp);
    }
    printf("\n");

  }
  printf("\n\n");


}

quadrupla GeraQuadrupla (int oper, operando opnd1, operando opnd2, operando result, int geradaTemp) {
  quadcorrente->prox = malloc(sizeof(celquad));
  quadcorrente = quadcorrente->prox;
  quadcorrente->oper = oper;
  quadcorrente->geradaTemp = geradaTemp;
  quadcorrente->opnd1 = opnd1;
  quadcorrente->opnd2 = opnd2;
  quadcorrente->result = result;
  quadcorrente->prox = NULL;
  numquadcorrente++;
  quadcorrente->num = numquadcorrente;
  return quadcorrente;
}

simbolo NovaTemp (int tip) {
  simbolo simb;
  int temp, i, j;
  char nometemp[10] = "##", s[10] = {0};
  numtemp++;
  temp = numtemp;
  int count = 0;
  for(i=0; temp>0; temp/=10, i++) {
    s[i] = temp % 10 + '0';
    count++;
  }
  i--;
  for (j=0; j<=i; j++) {
    nometemp[2+i-j] = s[j];
  }
  nometemp[count+2] = '\0';
  simb = InsereSimb(nometemp, IDVAR, tip);
  simb->inic = simb->ref = VERDADE;
  simb->array = FALSO;
  return simb;
}

void RenumQuadruplas (quadrupla q1, quadrupla q2) {
    printf("NOT IMPLEMENTED: RenumQuadruplas\n");
}

tabular () {
    int i;
    for (i = 1; i <= tab; i++)
    printf ("\t");
}

/*  InicTabSimb: Inicializa a tabela de simbolos   */

void InicTabSimb () {
    int i;
    for (i = 0; i < NCLASSHASH; i++)
        tabsimb[i] = NULL;
}

/*
    ProcuraSimb (cadeia, escopo): Procura cadeia na tabela de simbolos, em um dado escopo;
    Caso ela ali esteja, retorna um ponteiro para sua celula;
    Caso contrario, retorna NULL.
 */

simbolo ProcuraSimb (char *cadeia, char *escopo) {
    simbolo s; int i;
    i = hash (cadeia);
    for (s = tabsimb[i]; (s!=NULL) && ( strcmp(cadeia, s->cadeia)  || strcmp(escopo, s->escopo) );
        s = s->prox);
    //if(s != NULL) printf("iguais: c1:%s c2:%s e1:%s e2:%s",cadeia, s->cadeia, escopo, s->escopo);
    return s;
}


/*
    InsereSimb (cadeia, tid, tvar): Insere cadeia na tabela de
    simbolos, com tid como tipo de identificador e com tvar como
    tipo de variavel; Retorna um ponteiro para a celula inserida
 */

simbolo InsereSimb (char *cadeia, int tid, int tvar) {
    int i; simbolo aux, s;
    i = hash (cadeia); aux = tabsimb[i];
    s = tabsimb[i] = (simbolo) malloc (sizeof (celsimb));
    s->cadeia = (char*) malloc ((strlen(cadeia)+1) * sizeof(char));
    s->escopo = (char*) malloc ((strlen(escopocorrente)+1) * sizeof(char));
    strcpy (s->cadeia, cadeia);
    strcpy (s->escopo, escopocorrente);
    s->tid = tid;       s->tvar = tvar;
    s->inic = FALSO;    s->ref = FALSO;

    if (tid == IDFUNC) {
      s->param = (lista*) malloc (sizeof(lista));
      s->param->prox = NULL;
      s->param->tipo = 0;
    } else {
      s->param = NULL;
    }

    s->prox = aux;  return s;
}

void SetarEscopo (char *escopo) {
    escopocorrente = (char*) malloc ((strlen(escopo)+1)*sizeof(char));
    strcpy(escopocorrente, escopo);
}

/*
  Adiciona parametro
*/
void adicionaParametro () {
  simb = ProcuraSimb(escopocorrente, "GLOBAL");
  simb->param->tipo++;
  parametros p = simb->param;
  while (p->prox != NULL) {
    p = p->prox;
  }
  p->prox = (lista*) malloc (sizeof(lista));
  p->prox->prox = NULL;
  p->prox->tipo = tipocorrente;

}

/*
    hash (cadeia): funcao que determina e retorna a classe
    de cadeia na tabela de simbolos implementada por hashing
 */

int hash (char *cadeia) {
    int i, h;
    for (h = i = 0; cadeia[i]; i++) {h += cadeia[i];}
    h = h % NCLASSHASH;
    return h;
}

/* ImprimeTabSimb: Imprime todo o conteudo da tabela de simbolos  */

void ImprimeTabSimb () {
    // int i; simbolo s;
    // printf ("\n\n   TABELA  DE  SIMBOLOS:\n\n");
    // for (i = 0; i < NCLASSHASH; i++)
    //     if (tabsimb[i]) {
    //         printf ("Classe %d:\n", i);
    //         for (s = tabsimb[i]; s!=NULL; s = s->prox){
    //             printf ("  (%s, %s", s->cadeia,  nometipid[s->tid]);
    //             if (s->tid == IDVAR){
    //                 printf (", %s, Escopo: %s, %d, %d",
    //                     nometipvar[s->tvar], s->escopo, s->inic, s->ref);
    //                 if (s->array == VERDADE) {
    //                     int j;
    //                     printf (", EH ARRAY\n\tndims = %d, dimensoes:", s->ndims);
    //                     for (j = 1; j <= s->ndims; j++)
    //                                 printf ("  %d", s->dims[j]);
    //                 }
    //
    //             }
    //             if (s->tid == IDFUNC){
    //                 printf (", %s, Escopo: %s",nometipvar[s->tvar], s->escopo);
    //                 printf(", Quant de parametros: %d", s->param->tipo);
    //                 parametros p = s->param->prox;
    //                 if (s->param->prox > 0) {
    //                   printf(", Tipos dos paramentros: ");
    //                   while(p != NULL) {
    //                     if (p->prox == NULL) {
    //                       printf("%s", nometipvar[p->tipo]);
    //                     } else {
    //                       printf("%s, ", nometipvar[p->tipo]);
    //                     }
    //                     p = p->prox;
    //                   }
    //                 }
    //             }
    //             printf(")\n");
    //         }
    //     }
}

/*  Mensagens de erros semanticos  */

void DeclaracaoRepetida (char *s) {
    printf ("\n\n***** Declaracao Repetida: %s *****\n\n", s);
}


void NaoDeclarado (char *s) {
    printf ("\n\n***** Identificador Nao Declarado: %s *****\n\n", s);
}

void TipoInadequado (char *s) {
    printf ("\n\n***** Identificador de Tipo Inadequado: %s *****\n\n", s);
}

void TipoFuncaoInadequado (char *s) {
    printf ("\n\n***** Tipo de Funcao do Identificador Inadequado: %s *****\n\n", s);
}

void VerificaInicRef () {
    int i; simbolo s;

    printf ("\n");
    for (i = 0; i < NCLASSHASH; i++)
        if (tabsimb[i])
            for (s = tabsimb[i]; s!=NULL; s = s->prox)
                if (s->tid == IDVAR) {
                    if (s->inic == FALSO)
                        printf ("%s(Escopo: %s): Nao Inicializada\n", s->cadeia, s->escopo);
                    if (s->ref == FALSO)
                        printf ("%s(Escopo: %s): Nao Referenciada\n", s->cadeia, s->escopo);
                }
}

void Incompatibilidade (char *s) {
    printf ("\n\n***** Incompatibilidade: %s *****\n\n", s);
}

void Esperado (char *s) {
        printf ("\n\n***** Esperado: %s *****\n\n", s);
}

void NaoEsperado (char *s) {
printf ("\n\n***** Nao Esperado: %s *****\n\n", s);
}

void QuantidadeErradaDeArgumentos () {
    printf("\n\n***** Quantidade errada de argumentos na chamada de função. *****\n\n");
}

void RecursividadeNaoAdimitida() {
    printf("\n\n***** A linguagem não admite recursividade. *****\n\n");
}

void TipoErradoDeArgumentos (int tipoEsperado, int arg) {

    if (tipoEsperado == CARACTERE){
        printf("\n\n***** Tipo errado de argumento na chamada de função (argumento numero %d): esperava-se INTEIRO ou CARACTERE *****\n\n", arg);
    }
    else if (tipoEsperado == REAL){
        printf("\n\n***** Tipo errado de argumento na chamada de função (argumento numero %d): esperava-se INTEIRO, REAL OU CARACTERE *****\n\n", arg);

    }
    else if (tipoEsperado == INTEIRO){
        printf("\n\n***** Tipo errado de argumento na chamada de função (argumento numero %d): esperava-se INTEIRO ou CARACTERE *****\n\n", arg);
    }
    else if (tipoEsperado == LOGICO){
        printf("\n\n***** Tipo errado de argumento na chamada de função (argumento numero %d): esperava-se LOGICO *****\n\n", arg);

    }
}
