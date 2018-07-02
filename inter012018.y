%{

/* Inclusao de arquivos da biblioteca de C */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Definicao dos atributos dos atomos operadores */

#define 	LT 		    1
#define 	LE 	    	2
#define		GT			3
#define		GE			4
#define		EQ			5
#define		NE			6
#define		MAIS        7
#define		MENOS       8
#define		MULT    	9
#define		DIV   	    10
#define		RESTO   	11

/*   Definicao dos tipos de identificadores   */

#define 	IDPROG		1
#define 	IDVAR		2
#define 	IDFUNC		3

/*  Definicao dos tipos de variaveis   */

#define 	NAOVAR		0
#define 	INTEIRO		1
#define 	LOGICO		2
#define 	REAL		3
#define 	CARACTERE	4

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

/*   Definicao de outras constantes   */

#define	NCLASSHASH	23
#define	VERDADE		1
#define	FALSO		0
#define MAXDIMS		3

/*  Strings para nomes dos tipos de identificadores  */

char *nometipid[4] = {" ", "IDPROG", "IDVAR", "IDFUNC"};

/*  Strings para nomes dos tipos de variaveis  */

char *nometipvar[5] = {"NAOVAR",
	"INTEIRO", "LOGICO", "REAL", "CARACTERE"
};

/* Strings para operadores de quadruplas */

char *nomeoperquad[21] = {"",
	"OR", "AND", "LT", "LE", "GT", "GE", "EQ", "NE", "MAIS",
	"MENOS", "MULT", "DIV", "RESTO", "MENUN", "NOT", "ATRIB",
	"OPENMOD", "NOP", "JUMP", "JF"
};

/*
	Strings para tipos de operandos de quadruplas
 */

char *nometipoopndquad[9] = {"IDLE",
	"VAR", "INT", "REAL", "CARAC", "LOGIC", "CADEIA", "ROTULO", "MODULO"
};

/*    Declaracoes para a tabela de simbolos     */

typedef struct celsimb celsimb;
typedef celsimb *simbolo;
struct celsimb {
	char *cadeia;
	int tid, tvar, ndims, dims[MAXDIMS+1];
	char inic, ref, array ;
	simbolo prox;
};

/*  Variaveis globais para a tabela de simbolos e analise semantica */

simbolo tabsimb[NCLASSHASH];
simbolo simb;
int tipocorrente;

/*
	Prototipos das funcoes para a tabela de simbolos
    	e analise semantica
 */

void InicTabSimb (void);
void ImprimeTabSimb (void);
simbolo InsereSimb (char *, int, int);
int hash (char *);
simbolo ProcuraSimb (char *);
void DeclaracaoRepetida (char *);
void TipoInadequado (char *);
void NaoDeclarado (char *);
void VerificaInicRef (void);
void Incompatibilidade (char *);
void Esperado (char *);
void NaoEsperado (char *);

/* Declaracoes para a estrutura do codigo intermediario */

typedef union atribopnd atribopnd;
typedef struct operando operando;
typedef struct celquad celquad;
typedef celquad *quadrupla;
typedef struct celmodhead celmodhead;
typedef celmodhead *modhead;

union atribopnd {
	simbolo simb; int valint; float valfloat;
	char valchar; char vallogic; char *valcad;
	quadrupla rotulo; modhead modulo;
};

struct operando {
	int tipo; atribopnd atr;
};

struct celquad {
	int num, oper; operando opnd1, opnd2, result;
	quadrupla prox;
};

struct celmodhead {
	simbolo modname; modhead prox;
	quadrupla listquad;
};

/* Variaveis globais para o codigo intermediario */

quadrupla quadcorrente, quadaux;
modhead codintermed, modcorrente;
int oper, numquadcorrente;
operando opnd1, opnd2, result, opndaux;
int numtemp;
const operando opndidle = {IDLEOPND, 0};

/* Prototipos das funcoes para o codigo intermediario */

void InicCodIntermed (void);
void InicCodIntermMod (simbolo);
void ImprimeQuadruplas (void);
quadrupla GeraQuadrupla (int, operando, operando, operando);
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

/* Definicao do tipo de yylval e dos atributos dos nao terminais */

%union {
	char cadeia[50];
	int atr, valint;
	float valreal;
	char carac;
	simbolo simb;
	infoexpressao infoexpr;
	infovariavel infovar;
    int nsubscr;
}

/* Declaracao dos atributos dos tokens e dos nao-terminais */

%type	    <infovar>	    Variable
%type 	    <infoexpr> 	    Expression  AuxExpr1  AuxExpr2
                            AuxExpr3   AuxExpr4   Term   Factor
%type       <nsubscr>       Subscripts  SubscrList
%token		<cadeia>		ID
%token		<carac>		    CHARCT
%token		<cadeia>		STRING
%token		<valint>		INTCT
%token		<valreal>	    FLOATCT
%token		OR
%token		AND
%token		NOT
%token		<atr>			RELOP
%token		<atr>			ADOP
%token		<atr>			MULTOP
%token		NEG
%token		OPPAR
%token		CLPAR
%token		OPBRAK
%token		CLBRAK
%token		OPBRACE
%token		CLBRACE
%token		OPTRIP
%token		CLTRIP
%token		COMMA
%token		SCOLON
%token		ASSIGN
%token		CHAR
%token		DO
%token		ELSE
%token		FALSE
%token		FLOAT
%token		IF
%token		INT
%token		LOGIC
%token		READ
%token		STATEMENTS
%token		THEN
%token		TRUE
%token		VAR
%token		WHILE
%token		WRITE
%token		<carac>         INVAL
%%
/* Producoes da gramatica:

	Os terminais sao escritos e, depois de alguns,
	para alguma estetica, ha mudanca de linha       */

Prog			:	{
                        InicTabSimb ();
                    }  ID  OPTRIP  {
                        printf ("%s {{{\n", $2);
                        InsereSimb ($2, IDPROG, NAOVAR);

                    }  Decls  Stats  CLTRIP  {
                        printf ("}}}\n");
                        VerificaInicRef ();
                        ImprimeTabSimb ();
                    }
                ;
Decls 		    :
                |   VAR  OPBRACE  {printf ("var {\n");}  DeclList
                    CLBRACE  {printf ("}\n");}
                ;
DeclList		:	Declaration  |  DeclList  Declaration
                ;
Declaration 	:	Type  ElemList  SCOLON  {printf (";\n");}
                ;
Type			: 	INT  {printf ("int "); tipocorrente = INTEIRO;}
                |   FLOAT  {printf ("float "); tipocorrente = REAL;}
                |   CHAR  {printf ("char "); tipocorrente = CARACTERE;}
                |   LOGIC  {printf ("logic "); tipocorrente = LOGICO;}
                ;
ElemList    	:	Elem  |  ElemList  COMMA  {printf (", ");}  Elem
                ;
Elem        	:	ID  {
                        printf ("%s ", $1);
                        if  (ProcuraSimb ($1)  !=  NULL)
                            DeclaracaoRepetida ($1);
                        else {
                            simb = InsereSimb ($1,  IDVAR,  tipocorrente);
                            simb->array = FALSO; simb->ndims = 0;
                        }
                    }  Dims
                ;
Dims            :
                |   OPBRAK  {printf ("[ ");}  DimList
                    CLBRAK  {
                        printf ("] ");
                        simb->array = VERDADE;
                    }
                ;
DimList	    	:   INTCT  {
                        printf ("%d ", $1);
                        if ($1 <= 0) Esperado ("Valor inteiro positivo");
                        simb->ndims = 1; simb->dims[1] = $1;
                    }
                |   INTCT  COMMA  INTCT  {
                        printf ("%d , %d ", $1, $3);
                        if ($1 <= 0 || $3 <= 0) Esperado ("Valor inteiro positivo");
                        simb->ndims = 2;
                        simb->dims[1] = $1; simb->dims[2] = $3;
                    }
                |  	INTCT  COMMA  INTCT  COMMA  INTCT {
                        printf ("%d , %d , %d ", $1, $3, $5);
                        if ($1 <= 0 || $3 <= 0 || $5 <= 0) Esperado ("Valor inteiro positivo");
                        simb->ndims = 3;
                        simb->dims[1] = $1; simb->dims[2] = $3; simb->dims[3] = $5;
                    }
                ;
Stats       	:   STATEMENTS  {printf ("statements ");}  CompStat
                ;
CompStat		:   OPBRACE  {printf ("{\n");}  StatList  CLBRACE
                    {printf ("}\n");}
                ;
StatList		:
                |   StatList  Statement
                ;
Statement   	:   CompStat  |  IfStat  |  WhileStat  |  ReadStat
                |   WriteStat  |  AssignStat
                ;
IfStat		    :   IF  {printf ("if ");}  Expression  {
                        if ($3.tipo != LOGICO)
                            Incompatibilidade ("Expressao nao logica em comando if");
                    }  THEN
                    {printf ("then\n");}  Statement  ElseStat
                ;
ElseStat		:   |
                    ELSE  {printf ("else\n");}  Statement
                ;
WhileStat   	:	WHILE  {printf ("while ");}  Expression  {
                        if ($3.tipo != LOGICO)
                            Incompatibilidade ("Expressao nao logica em comando while");
                    }  DO  {printf ("do\n");}  Statement
                ;
ReadStat   	    :   READ  OPPAR  {printf ("read ( ");}  ReadList  CLPAR  SCOLON
                    {printf (") ;\n");}
                ;
ReadList		:   Variable  {
                        if  ($1.simb != NULL) $1.simb->inic = $1.simb->ref = VERDADE;
                    }
                |   ReadList  COMMA  {printf (", ");}  Variable  {
                        if  ($4.simb != NULL) $4.simb->inic = $4.simb->ref = VERDADE;
                    }
                ;
WriteStat   	:	WRITE  OPPAR  {printf ("write ( ");}  WriteList  CLPAR
                    SCOLON  {printf (") ;\n");}
                ;
WriteList		:	WriteElem  |  WriteList  COMMA  {printf (", ");}  WriteElem
                ;
WriteElem		:   STRING  {printf ("\"%s\" ", $1);}  |  Expression
                ;
AssignStat  	:   Variable  {
                        if  ($1.simb != NULL) $1.simb->inic = $1.simb->ref = VERDADE;
                    }
                    ASSIGN  {printf (":= ");}  Expression  SCOLON
                    {
                        printf (";\n");
                        if ($1.simb != NULL)
                            if ((($1.simb->tvar == INTEIRO || $1.simb->tvar == CARACTERE) &&
                                ($5.tipo == REAL || $5.tipo == LOGICO)) ||
                                ($1.simb->tvar == REAL && $5.tipo == LOGICO) ||
                                ($1.simb->tvar == LOGICO && $5.tipo != LOGICO))
                                Incompatibilidade ("Lado direito de comando de atribuicao improprio");
                    }
                ;
Expression  	:   AuxExpr1  |  Expression  OR  {printf ("|| ");}  AuxExpr1  {
                        if ($1.tipo != LOGICO || $4.tipo != LOGICO)
                            Incompatibilidade ("Operando improprio para operador or");
                        $$.tipo = LOGICO;
                    }
                ;
AuxExpr1    	:   AuxExpr2  |  AuxExpr1  AND  {printf ("&& ");}  AuxExpr2  {
                        if ($1.tipo != LOGICO || $4.tipo != LOGICO)
                            Incompatibilidade ("Operando improprio para operador and");
                        $$.tipo = LOGICO;
                    }
                ;
AuxExpr2    	:   AuxExpr3  |  NOT  {printf ("! ");}  AuxExpr3  {
                        if ($3.tipo != LOGICO)
                            Incompatibilidade ("Operando improprio para operador not");
                        $$.tipo = LOGICO;
                    }
                ;
AuxExpr3    	:   AuxExpr4
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
                                if ($1.tipo != INTEIRO && $1.tipo != REAL && $1.tipo != CARACTERE ||
                                    $4.tipo != INTEIRO && $4.tipo != REAL && $4.tipo != CARACTERE)
                                    Incompatibilidade	("Operando improprio para operador relacional");
                                break;
                            case EQ: case NE:
                                if (($1.tipo == LOGICO || $4.tipo == LOGICO) && $1.tipo != $4.tipo)
                                    Incompatibilidade ("Operando improprio para operador relacional");
                                break;
                        }
                        $$.tipo = LOGICO;
                    }
                ;
AuxExpr4    	:   Term
                |   AuxExpr4  ADOP  {
                        switch ($2) {
                            case MAIS: printf ("+ "); break;
                            case MENOS: printf ("- "); break;
                        }
                    }  Term  {
                        if ($1.tipo != INTEIRO && $1.tipo != REAL && $1.tipo != CARACTERE ||
                            $4.tipo != INTEIRO && $4.tipo!=REAL && $4.tipo!=CARACTERE)
                            Incompatibilidade ("Operando improprio para operador aritmetico");
                        if ($1.tipo == REAL || $4.tipo == REAL) $$.tipo = REAL;
                        else $$.tipo = INTEIRO;
                    }
                ;
Term  	    	:   Factor
                |   Term  MULTOP  {
                        switch ($2) {
                            case MULT: printf ("* "); break;
                            case DIV: printf ("/ "); break;
                            case RESTO: printf ("%% "); break;
                        }
                    }  Factor   {
                        switch ($2) {
                            case MULT: case DIV:
                                if ($1.tipo != INTEIRO && $1.tipo != REAL && $1.tipo != CARACTERE
                                    || $4.tipo != INTEIRO && $4.tipo!=REAL && $4.tipo!=CARACTERE)
                                    Incompatibilidade ("Operando improprio para operador aritmetico");
                                if ($1.tipo == REAL || $4.tipo == REAL) $$.tipo = REAL;
                                else $$.tipo = INTEIRO;
                                break;
                            case RESTO:
                                if ($1.tipo != INTEIRO && $1.tipo != CARACTERE
                                    ||  $4.tipo != INTEIRO && $4.tipo != CARACTERE)
                                    Incompatibilidade ("Operando improprio para operador resto");
                                $$.tipo = INTEIRO;
                                break;
                        }
                    }
                ;
Factor		    :   Variable  {
                        if  ($1.simb != NULL) {
                            $1.simb->ref  =  VERDADE;
                            $$.tipo = $1.simb->tvar;
                        }
                    }
                |   INTCT  {
                        printf ("%d ", $1);
                        $$.tipo = INTEIRO;
                    }
                |   FLOATCT  {
                        printf ("%g ", $1);
                        $$.tipo = REAL;
                    }
                |   CHARCT  {
                        printf ("\'%c\' ", $1);
                        $$.tipo = CARACTERE;
                    }
            	|   TRUE  {
                        printf ("true ");
                        $$.tipo = LOGICO;
                    }
            	|   FALSE  {
                        printf ("false ");
                        $$.tipo = LOGICO;
                    }
            	|   NEG  {printf ("~ ");}  Factor  {
                        if ($3.tipo != INTEIRO && $3.tipo != REAL && $3.tipo != CARACTERE)
                            Incompatibilidade  ("Operando improprio para menos unario");
                        if ($3.tipo == REAL) $$.tipo = REAL;
                        else $$.tipo = INTEIRO;
                    }
            	|   OPPAR  {printf ("( ");}  Expression
                    CLPAR  {printf (") "); $$.tipo = $3.tipo;}
                ;
Variable		:   ID  {
                        printf ("%s ", $1);
                        simb = ProcuraSimb ($1);
                        if (simb == NULL) NaoDeclarado ($1);
                        else if (simb->tid != IDVAR) TipoInadequado ($1);
                        $<simb>$ = simb;
                    }  Subscripts {
                        $$.simb = $<simb>2;
                        if ($$.simb != NULL) {
                            if ($$.simb->array == FALSO && $3 > 0)
                                NaoEsperado ("Subscrito\(s)");
                            else if ($$.simb->array == VERDADE && $3 == 0)
                                Esperado ("Subscrito\(s)");
                            else if ($$.simb->ndims != $3)
                                Incompatibilidade ("Numero de subscritos incompativel com declaracao");
                        }
                    }
                ;
Subscripts      :   {$$ = 0;}
                |   OPBRAK  {printf ("[ ");}  SubscrList
                    CLBRAK  {
                        printf ("] ");
                        $$ = $3;
                    }
                ;
SubscrList  	:   AuxExpr4 {
                        $$ = 1;
                        if ($1.tipo != INTEIRO && $1.tipo != CARACTERE)
                            Incompatibilidade ("Tipo inadequado para subscrito");
                    }
                |   TwoSubscr  {$$ = 2;}
                |   ThreeSubscr  {$$ = 3;}
                ;
TwoSubscr       :   AuxExpr4  COMMA  {printf (", ");}  AuxExpr4 {
                        if ($1.tipo != INTEIRO && $1.tipo != CARACTERE || $4.tipo != INTEIRO && $4.tipo != CARACTERE)
                            Incompatibilidade ("Tipo inadequado para subscrito");
                    }
                ;
ThreeSubscr     :   TwoSubscr  COMMA  {printf (", ");}  AuxExpr4 {
                        if ($4.tipo != INTEIRO && $4.tipo != CARACTERE)
                            Incompatibilidade ("Tipo inadequado para subscrito");
                    }
                ;
%%

/* Inclusao do analisador lexico  */

#include "lex.yy.c"

/*  InicTabSimb: Inicializa a tabela de simbolos   */

void InicTabSimb () {
	int i;
	for (i = 0; i < NCLASSHASH; i++)
		tabsimb[i] = NULL;
}

/*
	ProcuraSimb (cadeia): Procura cadeia na tabela de simbolos;
	Caso ela ali esteja, retorna um ponteiro para sua celula;
	Caso contrario, retorna NULL.
 */

simbolo ProcuraSimb (char *cadeia) {
	simbolo s; int i;
	i = hash (cadeia);
	for (s = tabsimb[i]; (s!=NULL) && strcmp(cadeia, s->cadeia);
		s = s->prox);
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
	strcpy (s->cadeia, cadeia);
	s->tid = tid;		s->tvar = tvar;
	s->inic = FALSO;	s->ref = FALSO;
	s->prox = aux;	return s;
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
	int i; simbolo s;
	printf ("\n\n   TABELA  DE  SIMBOLOS:\n\n");
	for (i = 0; i < NCLASSHASH; i++)
		if (tabsimb[i]) {
			printf ("Classe %d:\n", i);
			for (s = tabsimb[i]; s!=NULL; s = s->prox){
				printf ("  (%s, %s", s->cadeia,  nometipid[s->tid]);
				if (s->tid == IDVAR) {
					printf (", %s, %d, %d", nometipvar[s->tvar], s->inic, s->ref);
					if (s->array == VERDADE) { int j;
                        printf (", EH ARRAY\n\tndims = %d, dimensoes:", s->ndims);
						for (j = 1; j <= s->ndims; j++)
                            printf ("  %d", s->dims[j]);
					}
				}
				printf(")\n");
			}
		}
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

void VerificaInicRef () {
	int i; simbolo s;

	printf ("\n");
	for (i = 0; i < NCLASSHASH; i++)
		if (tabsimb[i])
			for (s = tabsimb[i]; s!=NULL; s = s->prox)
				if (s->tid == IDVAR) {
					if (s->inic == FALSO)
						printf ("%s: Nao Inicializada\n", s->cadeia);
					if (s->ref == FALSO)
						printf ("%s: Nao Referenciada\n", s->cadeia);
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

/* Funcoes para o codigo intermediario */

void InicCodIntermed () {
	modcorrente = codintermed = malloc (sizeof (celmodhead));
    modcorrente->listquad = NULL;
	modcorrente->prox = NULL;
}

void InicCodIntermMod (simbolo simb) {
	modcorrente->prox = malloc (sizeof (celmodhead));
	modcorrente = modcorrente->prox;
	modcorrente->prox = NULL;
	modcorrente->modname = simb;
	modcorrente->listquad = malloc (sizeof (celquad));
	quadcorrente = modcorrente->listquad;
	quadcorrente->prox = NULL;
	numquadcorrente = 0;
	quadcorrente->num = numquadcorrente;
}

quadrupla GeraQuadrupla (int oper, operando opnd1, operando opnd2,
	operando result) {
	quadcorrente->prox = malloc (sizeof (celquad));
	quadcorrente = quadcorrente->prox;
	quadcorrente->oper = oper;
	quadcorrente->opnd1 = opnd1;
	quadcorrente->opnd2 = opnd2;
	quadcorrente->result = result;
	quadcorrente->prox = NULL;
	numquadcorrente ++;
    quadcorrente->num = numquadcorrente;
    return quadcorrente;
}

simbolo NovaTemp (int tip) {
	simbolo simb; int temp, i, j;
	char nometemp[10] = "##", s[10] = {0};

	numtemp ++; temp = numtemp;
	for (i = 0; temp > 0; temp /= 10, i++)
		s[i] = temp % 10 + '0';
	i --;
	for (j = 0; j <= i; j++)
		nometemp[2+i-j] = s[j];
	simb = InsereSimb (nometemp, IDVAR, tip);
	simb->inic = simb->ref = VERDADE;
    simb->array = FALSO;
	return simb;
}

void ImprimeQuadruplas () {
	modhead p;
	quadrupla q;
	for (p = codintermed->prox; p != NULL; p = p->prox) {
		printf ("\n\nQuadruplas do modulo %s:\n", p->modname->cadeia);
		for (q = p->listquad->prox; q != NULL; q = q->prox) {
			printf ("\n\t%4d) %s", q->num, nomeoperquad[q->oper]);
			printf (", (%s", nometipoopndquad[q->opnd1.tipo]);
			switch (q->opnd1.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->opnd1.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->opnd1.atr.valint); break;
				case REALOPND: printf (", %g", q->opnd1.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->opnd1.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->opnd1.atr.vallogic); break;
				case CADOPND: printf (", %s", q->opnd1.atr.valcad); break;
				case ROTOPND: printf (", %d", q->opnd1.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->opnd1.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
			printf (", (%s", nometipoopndquad[q->opnd2.tipo]);
			switch (q->opnd2.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->opnd2.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->opnd2.atr.valint); break;
				case REALOPND: printf (", %g", q->opnd2.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->opnd2.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->opnd2.atr.vallogic); break;
				case CADOPND: printf (", %s", q->opnd2.atr.valcad); break;
				case ROTOPND: printf (", %d", q->opnd2.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->opnd2.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
			printf (", (%s", nometipoopndquad[q->result.tipo]);
			switch (q->result.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->result.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->result.atr.valint); break;
				case REALOPND: printf (", %g", q->result.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->result.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->result.atr.vallogic); break;
				case CADOPND: printf (", %s", q->result.atr.valcad); break;
				case ROTOPND: printf (", %d", q->result.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->result.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
		}
	}
   printf ("\n");
}

void RenumQuadruplas (quadrupla quad1, quadrupla quad2) {
	quadrupla q; int nquad;
	for (q = quad1->prox, nquad = quad1->num; q != quad2; q = q->prox) {
      nquad++;
		q->num = nquad;
	}
}

