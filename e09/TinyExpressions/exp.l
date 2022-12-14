%{
#include "y.tab.h"
#include <string.h>
 
extern int lineno;
extern int fileno();
%}

%option noyywrap nounput noinput

%%
[ \t]+        /* ignore */;
\n              lineno++;

"*"             return '*';
"/"             return '/';
"+"             return '+';
"-"             return '-';
"("             return '(';
")"             return ')';
"!"             return '!';
"&&"            return tAND;
"||"            return tOR;
"<="            return tLEQ;
"<"             return tLES;
"=="            return tEQ;


0|([1-9][0-9]*)        { yylval.intconst = atoi(yytext);
                         return tINTCONST; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.stringconst = (char *)malloc(strlen(yytext)+1);
                         sprintf(yylval.stringconst,"%s",yytext); 
                         return tIDENTIFIER; }
.               /* ignore */;
%%
