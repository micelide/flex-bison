%{
#include "attr.h"
#include "parse.tab.h"
#define YY_SKIP_YYWRAP
%}
	extern YYSTYPE yylval;
	extern int yywrap() {return 1;};
	extern int isatty();

%%

T {yylval.rpsType = TRU; return RPS;}
F {yylval.rpsType = FALS; return RPS;}
"&&" {yylval.rpsCond = AND; return COND;}
"||" {yylval.rpsCond = OR; return COND;}
"^" {yylval.rpsCond = XOR; return COND;}
"~" {yylval.rpsPunc = NOT; return PAREN;}
"(" {yylval.rpsPunc = LP; return PAREN;}
")" {yylval.rpsPunc = RP; return PAREN;}
. { return yytext[0]; }
[ \t] ;//ignore all whitespace

%%