%option noyywrap nodefault yylineno
%option case-insensitive
%option nounput noinput

%{
#include <ruby.h>
#include "parser.tab.h"
#include "ast.h"

#ifdef VERBOSE_PARSING

#define TOKEN_C(tok)                            \
    putchar(tok);                               \
    putchar('\n');                              \
    return tok;

#define TOKEN(tok)                              \
    puts(#tok);                                 \
    return tok;

#define TOKEN_V(tok, value)                     \
    printf("%s: \"%s\"\n", #tok, value);        \
    return tok;

#else /* !VERBOSE_PARSING */

#define TOKEN_C(tok)                            \
    return tok;

#define TOKEN(tok)                              \
    return tok;

#define TOKEN_V(tok, value)                     \
    return tok;

#endif /* VERBOSE_PARSING */

%}

%%

"(" | 
")" | 
"[" |
"]" |

"+" | 
"-" | 
"*" |
"/" |

"." |
"," |
":" |
";" | 

"^" |

"=" |
"<" | 
">" { TOKEN_C(yytext[0]); }

"=="                { TOKEN(EQ) }
"<>"                { TOKEN(NEQ) }
"<="                { TOKEN(LEQ) }
">="                { TOKEN(GEQ) }
":="                { TOKEN(COL_EQ) }
".."                { TOKEN(DOT_DOT) }

"and"               { TOKEN(KW_AND) }
"array"             { TOKEN(KW_ARRAY) }
"begin"             { TOKEN(KW_BEGIN) }
"case"              { TOKEN(KW_CASE) }
"const"             { TOKEN(KW_CONST) }
"div"               { TOKEN(KW_DIV) }
"do"                { TOKEN(KW_DO) }
"downto"            { TOKEN(KW_DOWNTO) }
"else"              { TOKEN(KW_ELSE) }
"end"               { TOKEN(KW_END) }
"file"              { TOKEN(KW_FILE) }
"for"               { TOKEN(KW_FOR) }
"function"          { TOKEN(KW_FUNCTION) }
"goto"              { TOKEN(KW_GOTO) }
"if"                { TOKEN(KW_IF) }
"in"                { TOKEN(KW_IN) }
"label"             { TOKEN(KW_LABEL) }
"mod"               { TOKEN(KW_MOD) }
"nil"               { TOKEN(KW_NIL) }
"not"               { TOKEN(KW_NOT) }
"of"                { TOKEN(KW_OF) }
"or"                { TOKEN(KW_OR) }
"packed"            { TOKEN(KW_PACKED) }
"procedure"         { TOKEN(KW_PROCEDURE) }
"program"           { TOKEN(KW_PROGRAM) }
"record"            { TOKEN(KW_RECORD) }
"repeat"            { TOKEN(KW_REPEAT) }
"set"               { TOKEN(KW_SET) }
"then"              { TOKEN(KW_THEN) }
"to"                { TOKEN(KW_TO) }
"type"              { TOKEN(KW_TYPE) }
"until"             { TOKEN(KW_UNTIL) }
"var"               { TOKEN(KW_VAR) }
"while"             { TOKEN(KW_WHILE) }
"with"              { TOKEN(KW_WITH) }

"'"([^']|"''")*"'"  { 
    /* string literal */
    yylval.ch = strdup(yytext); 
    TOKEN_V(STR_LTR, yylval.ch) 
}
"[-+]?[[:digit:]]+" { 
    /* integer literal */
    yylval.ch = strdup(yytext); 
    TOKEN_V(INT_LTR, yylval.ch) 
}
"[-+]?([0-9]*\.?[0-9]+|[0-9]+\.)(E(+|-)?[0-9]+)?" { 
    /* float literal */
    yylval.ch = strdup(yytext); 
    TOKEN_V(FLT_LTR, yylval.ch) 
}
[[:alpha:]_][[:alnum:]_]* { 
    /* identifier */
    yylval.ch = strdup(yytext); 
    TOKEN_V(IDENTIFIER, yylval.ch) 
}

"{"([^}]|"\n")*"}"  { /* skip comments */ }
[[:space:]]         { /* skip spaces */ }
.                   { yyerror(NULL, "unknown char %c", yytext[0]); }

%%


