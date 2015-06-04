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

%token ABSTRACT ASSERT BRACES_LEFT BRACES_RIGHT BRACKET_LEFT BRACKET_RIGHT BREAK CASE CATCH CLASS CONST CONTINUE DEFAULT DO ELSE ENUM EXTENDS FINAL FINALLY FOR GOTO IF IMPLEMENTS IMPORT INTERFACE LITERAL_FALSE LITERAL_NULL LITERAL_TRUE NATIVE NEW

%token OP_ASSIGN OP_BITWISEAND OP_BITWISENOT OP_BITWISEOR OP_BITWISEXOR OP_DECREMENT OP_DIVIDE OP_EQUAL OP_GREATER OP_GREATEROREQUAL OP_INCREMENT OP_INSTANCEOF OP_LESS OP_LESSOREQUAL OP_LOGICALAND OP_LOGICALOR OP_MINUS OP_MULTIPLY OP_NOT OP_NOTEQUAL OP_PLUS OP_REMAINDER OP_SHIFTLEFT OP_SHIFTRIGHT OP_TERNARYBEGIN OP_TERNARYBETWEEN OP_UNSIGNEDSHIFTRIGHT OP_ASSIGNDIVIDE OP_ASSIGNMULTIPLY OP_ASSIGNADD OP_ASSIGNSUBTRACT OP_ASSIGNREMAINDER OP_ASSIGNSHIFTLEFT OP_ASSIGNSHIFTRIGHT OP_ASSIGNUNSIGNEDSHIFTRIGHT OP_ASSIGNAND OP_ASSIGNXOR OP_ASSIGNOR

%token PACKAGE PARANTHESES_LEFT PARANTHESES_RIGHT PRIVATE PROTECTED PUBLIC RETURN STATIC STRICTFP SUPER SWITCH SYNCHRONIZED THIS THROW THROWS TRANSIENT TRY TYPE_BOOLEAN TYPE_BYTE TYPE_CHAR TYPE_DOUBLE TYPE_FLOAT TYPE_INT TYPE_LONG TYPE_SHORT VOID VOLATILE WHILE LITERAL_INTEGER LITERAL_FLOATING LITERAL_STRING LITERAL_CHARACTER

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

