/* This file contains declarations of functions needed by pascal parser */
#ifndef AST_H_
#define AST_H_

#include <ruby.h>
#include <stdio.h>

#ifdef VERBOSE_PARSING
#define STAMP() puts(__PRETTY_FUNCTION__)
#else
#define STAMP() do {} while(0)
#endif

extern VALUE mPascal;
extern VALUE cProgram;
extern VALUE cDeclarationLine;
extern VALUE cFunctionCall;
extern VALUE cStringLiteral;
extern VALUE cSyntaxError;

VALUE pas_string_literal(const char *literal);
VALUE pas_actual_parameter_list(VALUE fst, VALUE snd);
VALUE pas_procedure_statement(const char *name, VALUE parameters);
VALUE pas_statement_sequence(VALUE fst, VALUE snd);
VALUE pas_identifier_list(VALUE fst, const char *snd);
VALUE pas_variable_declaration(VALUE list, const char *type);
VALUE pas_variable_declaration_list(VALUE decl, VALUE list);
VALUE pas_variable_declaration_part(VALUE list);
VALUE pas_program(VALUE a, VALUE b);
VALUE pas_program_heading(const char* name);
VALUE pas_block(VALUE a, VALUE b);

extern int yyerror(VALUE *ast, const char * str, ...);
extern int yyparse(VALUE *ast);
extern FILE* yyin;
extern int yylineno;

#endif /* AST_H_ */
