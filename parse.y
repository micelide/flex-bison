%{
#include <stdio.h>
#include <stdlib.h>
#include "attr.h"
int yylex();
void yyerror(char *s);	
%}

%union {
	RPS_TYPE rpsType;
	RPS_COND rpsCond;
	RPS_PUNC rpsPunc;
}

%token <rpsType> RPS
%token <rpsCond> COND
%token <rpsPunc> PAREN


%type <rpsType> program atomic complex expr

%start program

%%
program : expr '.' { if($1 == TRU) { printf("T\n");}
					 else if($1 == FALS) {printf("F\n"); } 
					 else { yyerror("syntax error\n");}
				   }
		;

expr : atomic { }
	 | complex { }
	 ;

atomic : RPS { $$ = $1; }
	   | PAREN expr { if($1 == NOT) {
	   					switch($2) {
								case TRU: ($$ = FALS); 
								break;
								case FALS: ($$ = TRU); 
								break;
								default: yyerror("syntax error\n"); 
								break;
						}
	   					}
	   					else if($1 == LP) { $$ = $2; }
	   					else if($1 == RP) { }
	   					else { yyerror("syntax error\n"); }
	   			}
	   ;

complex : expr ' ' COND ' ' expr { 
			switch($3) {
				case AND:
				switch($1) {
					case TRU:
					switch($5) {
						case TRU:($$ = TRU); 
						break;
						case FALS: ($$ = FALS); 
						break;
					}
					break;
					case FALS: ($$ = FALS); 
					break;
				}
				break;
				case OR:
				switch($1) {
					case TRU: $$ = TRU; 
					break;
					case FALS:
					switch($5) {
						case TRU: $$ = TRU; 
						break;
						case FALS: $$ = FALS; 
						break;
						default: yyerror("syntax error\n");
					}
					break;
					default: yyerror("syntax error\n");
				}
				break;
				case XOR:
				switch($1) {
					case TRU:
					switch($5) {
						case TRU: $$ = FALS; 
						break;
						case FALS: $$ = TRU; 
						break;
					}
					break;
					case FALS:
					switch($5) {
						case TRU:($$ = TRU); break;
						case FALS: ($$ = FALS); break;
					}
					break;
					default: yyerror("syntax error\n");
				}
				break;
				default: yyerror("syntax error\n");
			}
		}
		;


%%

void yyerror(char* s) {
	fprintf(stderr, "%s\n", s);
	exit(0);
}

int main(int argc, char* argv[]) {
	yyparse();
	return 0;
}