%{
#include "aug_parser.h"

extern char* strdup(char* s);

int line_number = 1;
%}

%x COMMENT

sl_comment_open "//"
ml_comment_open "/*"
ml_comment_close "*/"

digit			[0-9]
number 			{digit}+

identifier 		[a-zA-Z][a-zA-Z{digit}]*
endl 			\n
whitespace 		[ \t]+

num_operator	"+"|"-"|"*"|"/"|"%"
bool_relation	"="|"<"|">"|"<="|">="
bracket			"("|")"
separator 		";"
assignment 		":="

%%

{sl_comment_open}.* 			{}
{ml_comment_open} 				{ BEGIN(COMMENT); }
<COMMENT>{ml_comment_close} 	{ BEGIN(INITIAL); }
<COMMENT>. 						{}
<COMMENT>{endl}					{ ++line_number; }

[ \t]           				;
"and"							{ return AND; }
"not"							{ return NOT; }
"or"							{ return OR; }

"do"							{ return DO; }
"else"							{ return ELSE; }
"if"							{ return IF; }
"then"							{ return THEN; }
"while"							{ return WHILE; }

"print"							{ return PRINT; }
"read"							{ return READ; }

"end"							{ return END; }
"exit"							{ return EXIT; }
"start"							{ return START; }

"true"							{ return TRUE_VAL; }
"false"							{ return FALSE_VAL; }

{num_operator}					{ yylval.num_operator = yytext[0]; return NUM_OPERATOR; }
{bool_relation}					{ yylval.string_value = strdup(yytext); return BOOL_RELATION; }
{bracket}						{ return yytext[0]; }
{separator}						{ return SEPARATOR; }
{assignment}					{ return ASSIGN; }
{number}+ 						{ yylval.value = atoi(yytext); return NUMBER; }
{identifier}      				{ yylval.string_value = strdup(yytext); return IDENT; }
{endl}							{ ++line_number; }
.								{}

%%
