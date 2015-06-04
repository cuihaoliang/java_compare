/*
 *  yacc file for java (probably incomplete) part of java_compare
 *  Copyright (C) 2015 Franz-Josef Anton Friedrich Haider
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

%{
#include <stdio.h>
#include <stdlib.h>

#include "integer_floating.h"

extern int yylex();
extern int yylineno;
extern char *yytext;
extern int yylex_destroy();

void yyerror(const char *msg);
%}

%union {
    char *identifier;
    struct integer_type *integer;
    struct floating_type *floating;
    char *string;
    char character;

    /* TODO */
    void *node;
}

%token <identifier>     IDENTIFIER
%token <integer>        INTEGER_VALUE
%token <floating>       FLOATING_VALUE
%token <string>         STRING_VALUE
%token <character>      CHARACTER_VALUE

%token ABSTRACT
%token ASSERT
%token BRACES_LEFT
%token BRACES_RIGHT
%token BRACKET_LEFT
%token BRACKET_RIGHT
%token BREAK
%token CASE
%token CATCH
%token CLASS
%token CONST
%token CONTINUE
%token DEFAULT
%token DO
%token ELSE
%token ENUM
%token EXTENDS
%token FINAL
%token FINALLY
%token FOR
%token GOTO
%token IF
%token IMPLEMENTS
%token IMPORT
%token INTERFACE
%token LITERAL_CHARACTER
%token LITERAL_FALSE
%token LITERAL_FLOATING
%token LITERAL_INTEGER
%token LITERAL_NULL
%token LITERAL_STRING
%token LITERAL_TRUE
%token NATIVE
%token NEW
%token OP_ASSIGN
%token OP_ASSIGNADD
%token OP_ASSIGNAND
%token OP_ASSIGNDIVIDE
%token OP_ASSIGNMULTIPLY
%token OP_ASSIGNOR
%token OP_ASSIGNREMAINDER
%token OP_ASSIGNSHIFTLEFT
%token OP_ASSIGNSHIFTRIGHT
%token OP_ASSIGNSUBTRACT
%token OP_ASSIGNUNSIGNEDSHIFTRIGHT
%token OP_ASSIGNXOR
%token OP_BITWISEAND
%token OP_BITWISENOT
%token OP_BITWISEOR
%token OP_BITWISEXOR
%token OP_DECREMENT
%token OP_DIVIDE
%token OP_EQUAL
%token OP_GREATER
%token OP_GREATEROREQUAL
%token OP_INCREMENT
%token OP_INSTANCEOF
%token OP_LESS
%token OP_LESSOREQUAL
%token OP_LOGICALAND
%token OP_LOGICALOR
%token OP_MINUS
%token OP_MULTIPLY
%token OP_NOT
%token OP_NOTEQUAL
%token OP_PLUS
%token OP_REMAINDER
%token OP_SHIFTLEFT
%token OP_SHIFTRIGHT
%token OP_TERNARYBEGIN
%token OP_TERNARYBETWEEN
%token OP_UNSIGNEDSHIFTRIGHT
%token PACKAGE
%token PARANTHESES_LEFT
%token PARANTHESES_RIGHT
%token PRIVATE
%token PROTECTED
%token PUBLIC
%token RETURN
%token STATIC
%token STRICTFP
%token SUPER
%token SWITCH
%token SYNCHRONIZED
%token THIS
%token THROW
%token THROWS
%token TRANSIENT
%token TRY
%token TYPE_BOOLEAN
%token TYPE_BYTE
%token TYPE_CHAR
%token TYPE_DOUBLE
%token TYPE_FLOAT
%token TYPE_INT
%token TYPE_LONG
%token TYPE_SHORT
%token VOID
%token VOLATILE
%token WHILE

%token _EOF 0           "end of file"

%start start

%%
/* TODO: identifier is only for testing purposes */
/* http://www.cs.dartmouth.edu/~mckeeman/cs118/notation/java11.html */
start                   : IDENTIFIER

%%

void parser_create()
{
}

void parser_destroy()
{
    yylex_destroy();
}

void yyerror(const char *msg)
{
    fprintf(stderr, "Error: Line %d: %s got \"%s\"\n", yylineno, msg, yytext);
}

