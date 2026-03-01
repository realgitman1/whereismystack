%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
%}

digit   [0-9]
number  {digit}+
ws      [ \t\r\n]+

%%

{ws}        {}

{number}    {
                yylval.val = atoll(yytext);
                return TOK_NUMBER;
            }

"+"         { return TOK_ADD; }
"-"         { return TOK_SUB; }
"*"         { return TOK_MUL; }
"/"         { return TOK_DIV; }
"="         { return TOK_EQUAL; }
"?"         { return TOK_QUESTION; }
"r"         { return TOK_REVERSE; }
"^"         { return TOK_CARET; }

<<EOF>>     { return 0; }

.           {
                fprintf(stderr,"Unknown char: %s\n", yytext);
                return TOK_ERROR;
            }

%%

int yywrap(void){
    return 1;
}

