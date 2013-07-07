#include "ast.h"

VALUE pas_program(VALUE name, VALUE rest)
{
    STAMP();
    rb_iv_set(rest, "@name", name);
    return rest;
}

VALUE pas_program_heading(const char* name, YYLTYPE location)
{
    STAMP();
    return make_ruby_token(name, location);
}

VALUE pas_block(VALUE decl, VALUE stmt)
{
    STAMP();
    VALUE prog = rb_class_new_instance(0, NULL, cProgram);
    rb_iv_set(prog, "@declarations", decl);
    rb_iv_set(prog, "@main", stmt);
    return prog;
}

VALUE pas_variable_declaration_part(VALUE list)
{
    STAMP();
    return (list) ? list : rb_ary_new();
}

VALUE pas_variable_declaration_list(VALUE list, VALUE decl)
{
    STAMP();
    if (!list)
        list = rb_ary_new();
    return rb_ary_push(list, decl);
}

VALUE pas_variable_declaration(VALUE list, const char *type, YYLTYPE location)
{
    STAMP();
    VALUE decl = rb_class_new_instance(0, NULL, cDeclarationLine);
    rb_iv_set(decl, "@variables", list);
    rb_iv_set(decl, "@type", make_ruby_token(type, location));
    return decl;
}

VALUE pas_identifier_list(VALUE list, const char *id, YYLTYPE location)
{
    STAMP();
    if (!list)
        list = rb_ary_new();
    list = rb_ary_push(list, make_ruby_token(id, location));
    return list;
}

VALUE pas_statement_sequence(VALUE seq, VALUE stmt)
{
    STAMP();
    if (!seq)
        seq = rb_ary_new();
    return rb_ary_push(seq, stmt);
}

VALUE pas_procedure_statement(const char* name, YYLTYPE location, VALUE arguments) 
{
    STAMP();
    VALUE call = rb_class_new_instance(0, NULL, cFunctionCall);
    rb_iv_set(call, "@name", make_ruby_token(name, location));
    rb_iv_set(call, "@arguments", arguments ? arguments : rb_ary_new());
    return call;
}

VALUE pas_actual_parameter_list(VALUE list, VALUE expr) 
{
    STAMP();
    if (!list)
        list = rb_ary_new();
    return rb_ary_push(list, expr);
}

VALUE pas_string_literal(const char * literal)
{
    STAMP();
    VALUE instance = rb_class_new_instance(0, NULL, cStringLiteral);
    rb_iv_set(instance, "@string", rb_str_new2(literal));
    free((char*) literal);
    return instance;
}

VALUE pas_assignment_statement(const char *name, YYLTYPE location, VALUE expr)
{
    STAMP();
    VALUE instance = rb_class_new_instance(0, NULL, cAssignmentStatement);
    rb_iv_set(instance, "@expression", expr);
    rb_iv_set(instance, "@name", make_ruby_token(name, location));
    return instance;
}

VALUE pas_evaluate_variable(const char *name, YYLTYPE location)
{
    STAMP();
    VALUE instance = rb_class_new_instance(0, NULL, cEvaluateVariable);
    rb_iv_set(instance, "@name", make_ruby_token(name, location));
    return instance;
}
