%option noyywrap nodefault yylineno
%option case-insensitive
%option nounput noinput

%{
#include <ruby.h>
#include "parser.h"
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

/* handle locations */
int yycolumn = 1;

#define YY_USER_ACTION yylloc.filename = filename; \
    yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; yylloc.last_column = yycolumn+yyleng-1; \
    yycolumn += yyleng;

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

"{"([^}]|"\n")*"}"  { /* skip comments */ 
                        char* ptr = yytext + yyleng - 1;
                        char* ptr0 = ptr;
                        while (ptr >= yytext) {
                            if (*ptr == '\n') {
                                yycolumn = ptr0 - ptr + 1;
                                break;
                            }
                            --ptr;
                        }
                    }

[ \t]               { /* skip spaces */ }
\n                  { yycolumn = 1; }
.                   { yyerror(NULL, "unknown char %c", yytext[0]); }

%%


