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

const char *filename; /* current filename here for the lexer */

typedef struct YYLTYPE {
    int first_line;
    int first_column;
    int last_line;
    int last_column;
    const char *filename;
} YYLTYPE;

# define YYLTYPE_IS_DECLARED 1

# define YYLLOC_DEFAULT(Current, Rhs, N)				        \
    do									                        \
      if (YYID (N))                                             \
	{								                            \
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
      (Current).filename     = YYRHSLOC (Rhs, 1).filename;      \
	}								                            \
      else								                        \
	{								                            \
	  (Current).first_line   = (Current).last_line   =		    \
	    YYRHSLOC (Rhs, 0).last_line;				            \
	  (Current).first_column = (Current).last_column =		    \
	    YYRHSLOC (Rhs, 0).last_column;				            \
      (Current).filename = YYRHSLOC (Rhs, 0).filename;          \
	}								                            \
    while (YYID (0))


extern VALUE mPascal;
extern VALUE cToken;
extern VALUE cBasicEntity;

extern VALUE mAST;
extern VALUE cStatement;
extern VALUE cExpression;
extern VALUE cProgram;
extern VALUE cDeclarationLine;
extern VALUE cFunctionCall;
extern VALUE cStringLiteral;
extern VALUE cAssignmentStatement;
extern VALUE cEvaluateVariable;

extern VALUE cSyntaxError;

VALUE pas_string_literal(const char *literal);
VALUE pas_actual_parameter_list(VALUE fst, VALUE snd);
VALUE pas_procedure_statement(const char *name, YYLTYPE location, VALUE arguments);
VALUE pas_statement_sequence(VALUE fst, VALUE snd);
VALUE pas_identifier_list(VALUE fst, const char *snd, YYLTYPE location);
VALUE pas_variable_declaration(VALUE list, const char *type, YYLTYPE location);
VALUE pas_variable_declaration_list(VALUE decl, VALUE list);
VALUE pas_variable_declaration_part(VALUE list);
VALUE pas_program(VALUE a, VALUE b);
VALUE pas_program_heading(const char* name, YYLTYPE location);
VALUE pas_block(VALUE a, VALUE b);

VALUE pas_assignment_statement(const char *name, YYLTYPE location, VALUE expr);
VALUE pas_evaluate_variable(const char *name, YYLTYPE location);

extern int yyerror(VALUE *ast, const char * str, ...);
extern int yyparse(VALUE *ast);
extern FILE* yyin;
extern int yylineno;

VALUE make_ruby_token(const char *identifier /* new token will take ownership of this ptr */,
                      YYLTYPE     location   /* new token will make a copy of filename */);


#endif /* AST_H_ */
