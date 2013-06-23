#include <stdio.h>
#include <ruby.h>
#include "ast.h"
#include "parser.tab.h"

VALUE mPascal;
VALUE cProgram;
VALUE cDeclarationLine;
VALUE cFunctionCall;
VALUE cStringLiteral;
VALUE cSyntaxError;

static VALUE parse_file(VALUE self, VALUE fd)
{
    yyin = fdopen(NUM2INT(fd), "r");

    if (!yyin) {
        perror("pascal.so"); /* TODO */
    }

    VALUE ast;
    if (yyparse(&ast)) {
        //VALUE exception = rb_class_new_instance(0, NULL, cSyntaxError);
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

void Init_pascal()
{
    mPascal = rb_define_module("Pascal");
    rb_define_module_function(mPascal, "parse_file", parse_file, 1);

    cProgram = 
        rb_define_class_under(mPascal, "Program", rb_cObject);

    cDeclarationLine = 
        rb_define_class_under(mPascal, "DeclarationLine", rb_cObject);

    cFunctionCall = 
        rb_define_class_under(mPascal, "FunctionCall", rb_cObject);

    cStringLiteral = 
        rb_define_class_under(mPascal, "StringLiteral", rb_cObject);

    cSyntaxError =
        rb_define_class_under(mPascal, "SyntaxError", rb_eRuntimeError);
}

void Init_pascal_verbose()
{
    Init_pascal();
}
