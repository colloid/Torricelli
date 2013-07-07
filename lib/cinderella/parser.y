%parse-param { VALUE *ast }
%locations

%{
%}

%code requires {
#include "ast.h"
extern int yylex(void);
}

%union { 
    VALUE rb;
    const char* ch;
}

%token <ch> EQ NEQ LEQ GEQ COL_EQ DOT_DOT STR_LTR INT_LTR FLT_LTR KW_AND KW_ARRAY KW_BEGIN KW_CASE KW_CONST KW_DIV KW_DO KW_DOWNTO KW_ELSE KW_END KW_FILE KW_FOR KW_FUNCTION KW_GOTO KW_IF KW_IN KW_LABEL KW_MOD KW_NIL KW_NOT KW_OF KW_OR KW_PACKED KW_PROCEDURE KW_PROGRAM KW_RECORD KW_REPEAT KW_SET KW_THEN KW_TO KW_TYPE KW_UNTIL KW_VAR KW_WHILE KW_WITH IDENTIFIER

%type <rb> PROGRAM PROGRAM_HEADING BLOCK
%type <rb> VARIABLE_DECLARATION_PART VARIABLE_DECLARATION_LIST
%type <rb> VARIABLE_DECLARATION IDENTIFIER_LIST COMPOUND_STATEMENT
%type <rb> STATEMENT_SEQUENCE STATEMENT PROCEDURE_STATEMENT
%type <rb> ACTUAL_PARAMETER_LIST ACTUAL_PARAMETER EXPRESSION
%type <rb> ASSIGNMENT_STATEMENT

%left '+' '-'
%left '>'
%left '*' '/'

%%

PROGRAM :
      PROGRAM_HEADING ';' BLOCK /* std: PROGRAM_BLOCK */ '.' 
            { *ast = pas_program($1, $3); }
;

PROGRAM_HEADING :
      KW_PROGRAM IDENTIFIER 
            { $$ = pas_program_heading($2, @2); }
;

BLOCK :
      VARIABLE_DECLARATION_PART COMPOUND_STATEMENT 
            { $$ = pas_block($1, $2); }
;

VARIABLE_DECLARATION_PART :
      /* nothing */
            { $$ = pas_variable_declaration_part(0); }
    | KW_VAR VARIABLE_DECLARATION_LIST 
            { $$ = pas_variable_declaration_part($2); }
;

VARIABLE_DECLARATION_LIST :
      VARIABLE_DECLARATION
            { $$ = pas_variable_declaration_list(0, $1);}
    | VARIABLE_DECLARATION_LIST VARIABLE_DECLARATION
            { $$ = pas_variable_declaration_list($1, $2); }
;

VARIABLE_DECLARATION :
      IDENTIFIER_LIST ':' IDENTIFIER ';'
            { $$ = pas_variable_declaration($1, $3, @3); }
;

IDENTIFIER_LIST :
      IDENTIFIER 
            { $$ = pas_identifier_list(0, $1, @1); }
    | IDENTIFIER_LIST ',' IDENTIFIER
            { $$ = pas_identifier_list($1, $3, @3); }
;

COMPOUND_STATEMENT :
      KW_BEGIN STATEMENT_SEQUENCE KW_END 
            { $$ = $2; }
;

STATEMENT_SEQUENCE :
      STATEMENT 
            { $$ = pas_statement_sequence(0, $1); }
    | STATEMENT_SEQUENCE ';' STATEMENT
            { $$ = pas_statement_sequence($1, $3); }
;

STATEMENT :
      PROCEDURE_STATEMENT 
            { $$ = $1; }
    | ASSIGNMENT_STATEMENT
            { $$ = $1; }
;

PROCEDURE_STATEMENT :
      IDENTIFIER '(' ACTUAL_PARAMETER_LIST ')' 
            { $$ = pas_procedure_statement($1, @1, $3); }
    | IDENTIFIER '(' ')' 
            { $$ = pas_procedure_statement($1, @1, 0); }
;

ASSIGNMENT_STATEMENT :
      IDENTIFIER COL_EQ EXPRESSION
            { $$ = pas_assignment_statement($1, @1, $3); }
;

ACTUAL_PARAMETER_LIST :
      ACTUAL_PARAMETER 
            { $$ = pas_actual_parameter_list(0, $1); }
    | ACTUAL_PARAMETER_LIST ',' ACTUAL_PARAMETER
            { $$ = pas_actual_parameter_list($1, $3); }
;

ACTUAL_PARAMETER :
      EXPRESSION 
            { $$ = $1; }
;

EXPRESSION :
      STR_LTR 
            { $$ = pas_string_literal($1); }
    | IDENTIFIER
            { $$ = pas_evaluate_variable($1, @1); }
;
      
%%  
