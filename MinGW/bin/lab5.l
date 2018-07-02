%{
void comentario (void);
%}
delim		[ \t\n\r]
ws			{delim}+
digito	    [0-9]
letra		[A-Za-z]
id			{letra}({letra}|{digito})*
intct		{digito}+
carac1		\\.|[^\\']
charct		'{carac1}'
floatct     {digito}+\.{digito}*([Ee][+-]?{digito}+)?
carac2		\\.|[^\\\"]
string		\"{carac2}*\"

%%

{ws}		{ ;}
call 		{return CALL;} 
char 		{return CHAR;}
do 			{return DO;}
else		{return ELSE;}
false 		{return FALSE;}
float 		{return FLOAT;}
for 		{return FOR;}
if			{return IF;}
int 		{return INT;}
logic  		{return LOGIC;}
main  		{return MAIN;}
read  		{return READ;}
repeat  	{return REPEAT;}
return 		{return RETURN;}
statements 	{return STATEMENTS;}
then 		{return THEN;}
true 		{return TRUE;}
var 		{return VAR;}
void 		{return VOID ;}
while		{return WHILE;}
write 		{return WRITE;}

{id}		{strcpy (yylval.string, yytext); return ID;}
{intct}	    {yylval.valor = atoi(yytext); return INTCT;}
{floatct}	{yylval.valreal = atof(yytext); return FLOATCT;}
{charct}	{strcpy (yylval.string, yytext); return CHARCT;}
{string}	{strcpy (yylval.string, yytext); return STRING;}

"||"		{return OR;}
"&&" 		{return AND;}
"!"	 		{return NOT;}

"<"		    {yylval.atr = LT; return RELOP;}
"<="		{yylval.atr = LE; return RELOP;}
">"		    {yylval.atr = GT; return RELOP;}
">="		{yylval.atr = GE; return RELOP;}
"="			{yylval.atr = EQ; return RELOP;}
"!="		{yylval.atr = NE; return RELOP;}

"+"			{yylval.atr = PLUS; return ADOP;}
"-" 		{yylval.atr = MINUS; return ADOP;}
"*" 		{yylval.atr = MULT; return MULTOP;}
"/"			{yylval.atr = DIV; return MULTOP;}
"%"			{yylval.atr = MOD; return MULTOP;} 		
"~" 		{return NEG;}

"(" 		{return OPPAR;}
")" 		{return CLPAR;}
"["  		{return OPBRAK;}
"]" 		{return CLBRAK;}
"{" 		{return OPBRACE;}
"}"     	{return CLBRACE;}
"{{{" 		{return OPTRIP;}
"}}}" 		{return CLTRIP;}
";"   		{return SCOLON;}
"," 		{return COMMA;}
":" 		{return COLON;}
":=" 		{return ASSIGN;}
"/*" 		{comentario();}

.			{yylval.carac = yytext[0]; return INVAL;}

%%

void comentario()
{
	char c;
	int estado;
	estado = 1;
	while (estado != 3) {
		switch (estado) {
			case 1:
				c = input ();
				if (c == EOF) estado = 3;
				else if (c == '*') estado = 2;
				break;
			case 2:
				c = input();
				if(c == EOF) estado = 3;
				else if (c == '/') estado = 3;
				else if (c == '*') estado = 2;
				else estado  = 1;
				break;
		}
	}
}

