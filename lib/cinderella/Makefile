.PHONY: all clean

include $(HOME)/mf.conf

LIBNAME = cinderella
all: $(LIBNAME).so $(LIBNAME)_verbose.so

C_SOURCES = gate.c ast.c
Y_SOURCES = parser.y
L_SOURCES = lexer.c
SOURCES = $(C_SOURCES) $(Y_SOURCES:%.y=%.c) $(L_SOURCES:%.l=%.c)
OBJECTS = $(SOURCES:%.c=%.o)
OBJECTS_VERBOSE = $(OBJECTS:%.o=%_verbose.o)

gate.c: parser.c ast.h
lexer.c: parser.c ast.h
ast.c: ast.h

CFLAGS   = -fPIC -g -O0 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror -Wall -fno-strict-aliasing
YFLAGS = -vd

%.o: %.c
	$(COMPILE.c) $< -o $@ $(RUBY_INCLUDE)

%_verbose.o: %.c
	$(COMPILE.c) $< -o $@ $(RUBY_INCLUDE) -DVERBOSE_PARSING

%.c: %.y
	$(YACC.y) -o $@ $<

$(LIBNAME).so: $(OBJECTS)
	$(LINK.c) -shared -o $@ $^

$(LIBNAME)_verbose.so: $(OBJECTS_VERBOSE)	
	$(LINK.c) -shared -o $@ $^

clean:
	@-rm -f $(LIBNAME).so $(LIBNAME)_verbose.so $(OBJECTS) $(OBJECTS_VERBOSE) \
      $(Y_SOURCES:%.y=%.c) $(Y_SOURCES:%.y=%.h) $(Y_SOURCES:%.y=%.output)     \
	  $(L_SOURCES:%.l=%.c) core
