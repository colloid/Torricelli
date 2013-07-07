#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <ruby.h>

#include "ast.h"

VALUE mPascal;
VALUE cToken;
VALUE cBasicEntity;

VALUE mAST;
VALUE cStatement;
VALUE cExpression;
VALUE cProgram;
VALUE cDeclarationLine;
VALUE cFunctionCall;
VALUE cStringLiteral;
VALUE cAssignmentStatement;
VALUE cEvaluateVariable;

VALUE cSyntaxError;

VALUE make_ruby_token(const char *identifier, YYLTYPE location)
{
    VALUE token = rb_class_new_instance(0, NULL, cToken);
    rb_iv_set(token, "@identifier", rb_str_new2(identifier));
    rb_iv_set(token, "@filename", rb_str_new2(location.filename));
    rb_iv_set(token, "@lineno", INT2NUM(location.first_line));
    rb_iv_set(token, "@column", INT2NUM(location.first_column));
    free((void*) identifier);
    return token;
}

static VALUE parse_file(VALUE self, VALUE fname)
{
    filename = rb_string_value_cstr(&fname);
    yyin = fopen(filename, "r");

    if (!yyin) {
        rb_raise(rb_eRuntimeError, "pascal.so: parse_file: %s", 
                 strerror(errno));
    }

    VALUE ast;
    if (yyparse(&ast)) {
        rb_raise(cSyntaxError, "Syntax error");
    }
    return ast;
}

int yyerror(VALUE *ast, const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);

    vprintf(fmt, ap);
    putchar('\n');
    return 0;
}

void Init_cinderella()
{
    mPascal = rb_define_module("Pascal");

    rb_define_module_function(mPascal, "parse_file", parse_file, 1);

    cToken =
        rb_define_class_under(mPascal, "Token", rb_cObject);

    cSyntaxError =
        rb_define_class_under(mPascal, "SyntaxError", rb_eRuntimeError);

    cBasicEntity =
        rb_define_class_under(mPascal, "BasicEntity", rb_cObject);

    mAST =
        rb_define_module_under(mPascal, "AST");

    cStatement =
        rb_define_class_under(mAST, "Statement", cBasicEntity);

    cExpression =
        rb_define_class_under(mAST, "Expression", cStatement);

    cProgram = 
        rb_define_class_under(mAST, "Program", cBasicEntity);

    cDeclarationLine = 
        rb_define_class_under(mAST, "DeclarationLine", cBasicEntity);

    cFunctionCall = 
        rb_define_class_under(mAST, "FunctionCall", cExpression);

    cStringLiteral = 
        rb_define_class_under(mAST, "StringLiteral", cExpression);

    cAssignmentStatement = 
        rb_define_class_under(mAST, "AssignmentStatement", cStatement);

    cEvaluateVariable =
        rb_define_class_under(mAST, "EvaluateVariable", cExpression);
}

void Init_cinderella_verbose()
{
    Init_cinderella();
}
