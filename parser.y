/*
 *  yacc file for java (incomplete) part of java_compare
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

%code requires {
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "integer_floating.h"

#include "ast.h"

extern int yylex();
extern int yylineno;
extern char *yytext;
extern int yylex_destroy();

extern void parser_create();
extern void parser_destroy();
int yyparse(void);
void yyerror(const char *msg);
}

%union {
    char *identifier;
    integer_type integer;
    floating_type floating;
    char *string;
    char character;
    int boolean;

    ast_node *node;
}

%token _EOF 0       "end of file"

%token  OP_PLUS
%token  OP_MINUS
%token  OP_MULTIPLY
%token  OP_DIVIDE
%token  OP_REMAINDER
%token  OP_SHIFTLEFT
%token  OP_SHIFTRIGHT
%token  OP_UNSIGNEDSHIFTRIGHT
%token  OP_BITWISEAND
%token  OP_BITWISEXOR
%token  OP_BITWISEOR
%token  OP_LOGICALAND
%token  OP_LOGICALOR
%token  OP_EQUAL
%token  OP_NOTEQUAL
%token  OP_GREATERTHAN
%token  OP_GREATERTHANOREQUAL
%token  OP_LESSTHAN
%token  OP_LESSTHANOREQUAL

%token  OP_DIM

%token  OP_ASSIGNADD
%token  OP_ASSIGNSUBTRACT
%token  OP_ASSIGNMULTIPLY
%token  OP_ASSIGNDIVIDE
%token  OP_ASSIGNREMAINDER
%token  OP_ASSIGNSHIFTLEFT
%token  OP_ASSIGNSHIFTRIGHT
%token  OP_ASSIGNUNSIGNEDSHIFTRIGHT
%token  OP_ASSIGNBITWISEAND
%token  OP_ASSIGNBITWISEXOR
%token  OP_ASSIGNBITWISEOR

%token  PUBLIC
%token  PRIVATE
%token  PROTECTED
%token  STATIC
%token  FINAL
%token  SYNCHRONIZED
%token  VOLATILE
%token  TRANSIENT
%token  NATIVE
%token  ABSTRACT
%token  STRICTFP
%token  MODIFIER

 /* TODO? */
%token  ENUM

%token  OP_DECREMENT
%token  OP_INCREMENT

%token  DEFAULT
%token  IF
%token  THROW
%token  DO
%token  IMPLEMENTS
%token  THROWS
%token  BREAK
%token  IMPORT
%token  ELSE
%token  RETURN
%token  VOID
%token  CATCH
%token  INTERFACE
%token  CASE
%token  EXTENDS
%token  FINALLY
%token  SUPER
%token  WHILE
%token  CLASS
%token  SWITCH
%token  CONST
%token  TRY
%token  FOR
%token  NEW
%token  CONTINUE
%token  GOTO
%token  PACKAGE
%token  THIS
%token  ASSERT

 /* types */
%token  TYPE_BYTE
%token  TYPE_SHORT
%token  TYPE_INT
%token  TYPE_LONG
%token  TYPE_CHAR
%token  TYPE_FLOAT
%token  TYPE_DOUBLE
%token  TYPE_BOOLEAN

%token  IDENTIFIER

%token  OP_TERNARYBEGIN
%token  OP_TERNARYBETWEEN
%token  OP_BITWISENOT
%token  OP_NOT

%token  OP_ASSIGN

%token  PARANTHESES_LEFT
%token  PARANTHESES_RIGHT
%token  BRACES_LEFT
%token  BRACES_RIGHT
%token  BRACKET_LEFT
%token  BRACKET_RIGHT

%token  OP_SEMICOLON
%token  OP_COLON
%token  OP_DOT

%token  LITERAL_STRING
%token  LITERAL_CHARACTER
%token  LITERAL_INTEGER
%token  LITERAL_FLOATING
%token  LITERAL_BOOLEAN
%token  LITERAL_NULL

%token OP_INSTANCEOF

%nonassoc PARANTHESES_RIGHT
%nonassoc ELSE

%type <node> CompilationUnit
%type <node> ProgramFile
%type <node> PackageStatement
%type <node> ImportStatements
%type <node> ImportStatement
%type <node> TypeDeclarations

%type <node> QualifiedName

%type <node> TypeDeclaration
%type <node> TypeDeclarationOptSemi

%type <node> ClassHeader

%type <node> Modifiers
%type <node> ClassWord
%type <node> Extends
%type <node> Interfaces

%type <node> FieldDeclarations
%type <node> FieldDeclarationOptSemi
%type <node> FieldDeclaration
%type <node> FieldVariableDeclaration
%type <node> MethodDeclaration
%type <node> ConstructorDeclaration
%type <node> StaticInitializer
%type <node> NonStaticInitializer

%type <node> Modifier

%type <node> PrimitiveType
%type <node> TypeName
%type <node> TypeSpecifier

%type <node> ClassNameList
%type <node> Dims

%type <node> MethodBody

%type <node> MethodDeclarator
%type <node> DeclaratorName

%type <node> Throws

%type <node> ParameterList
%type <node> Parameter

%type <node> VariableDeclarator
%type <node> VariableDeclarators

%type <node> Block

%type <identifier> IDENTIFIER

%start CompilationUnit

%%

 /* grammar based on http://home.comcast.net/~bronnikov/java11.y */

 /*------------------------------------------------------------------
  * Copyright (C)
  *   1996, 1997, 1998 Dmitri Bronnikov, All rights reserved.
  *
  * THIS GRAMMAR IS PROVIDED "AS IS" WITHOUT  ANY  EXPRESS  OR
  * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  * WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS  FOR  A  PARTICULAR
  * PURPOSE, OR NON-INFRINGMENT.
  *
  * Bronikov@inreach.com
  *
  *------------------------------------------------------------------
  *
  * VERSION 1.06 DATE 20 AUG 1998
  *
  *------------------------------------------------------------------
  *
  * UPDATES
  *
  * 1.06 Correction of Java 1.1 syntax
  * 1.05 Yet more Java 1.1
  *      <qualified name>.<allocation expression>
  * 1.04 More Java 1.1 features:
  *      <class name>.this
  *      <type name>.class
  * 1.03 Added Java 1.1 features:
  *      inner classes,
  *      anonymous classes,
  *      non-static initializer blocks,
  *      array initialization by new operator
  * 1.02 Corrected cast expression syntax
  * 1.01 All shift/reduce conflicts, except dangling else, resolved
  *
  *------------------------------------------------------------------
  *
  * PARSING CONFLICTS RESOLVED
  *
  * Some Shift/Reduce conflicts have been resolved at the expense of
  * the grammar defines a superset of the language. The following
  * actions have to be performed to complete program syntax checking:
  *
  * 1) Check that modifiers applied to a class, interface, field,
  *    or constructor are allowed in respectively a class, inteface,
  *    field or constructor declaration. For example, a class
  *    declaration should not allow other modifiers than abstract,
  *    final and public.
  *
  * 2) For an expression statement, check it is either increment, or
  *    decrement, or assignment expression.
  *
  * 3) Check that type expression in a cast operator indicates a type.
  *    Some of the compilers that I have tested will allow simultaneous
  *    use of identically named type and variable in the same scope
  *    depending on context.
  *
  * 4) Change lexical definition to change '[' optionally followed by
  *    any number of white-space characters immediately followed by ']'
  *    to OP_DIM token. I defined this token as [\[]{white_space}*[\]]
  *    in the lexer.
  *
  *------------------------------------------------------------------
  *
  * UNRESOLVED SHIFT/REDUCE CONFLICTS
  *
  * Dangling else in if-then-else
  *
  *------------------------------------------------------------------
  */
TypeSpecifier
    : TypeName
        {
            $$ = node_create(NODE_TYPESPECIFIER);
            $$->u.body[0] = $1;
            $$->u.body[1] = NULL;
        }
    | TypeName Dims
        {
            $$ = node_create(NODE_TYPESPECIFIER);
            $$->u.body[0] = $1;
            $$->u.body[1] = $2;
        }
    ;

TypeName
    : PrimitiveType
        {
            $$ = $1;
        }
    | QualifiedName
        {
            $$ = $1;
        }
    ;

ClassNameList
    : QualifiedName
        {
            $$ = $1;
        }
    | ClassNameList OP_COLON QualifiedName
        {
            $$ = $1;
            add_to_list($1, $3);
        }
    ;

PrimitiveType
    : TYPE_BOOLEAN
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "boolean");
        }
    | TYPE_CHAR
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "char");
        }
    | TYPE_BYTE
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "byte");
        }
    | TYPE_SHORT
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "short");
        }
    | TYPE_INT
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "int");
        }
    | TYPE_LONG
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "long");
        }
    | TYPE_FLOAT
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "float");
        }
    | TYPE_DOUBLE
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "double");
        }
    | VOID
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "void");
        }
    ;

SemiColons
    : OP_SEMICOLON
    | SemiColons OP_SEMICOLON
    ;

CompilationUnit
    : ProgramFile
        {
            $$ = $1;
            current_root = $$;
        }
    ;

ProgramFile
    : PackageStatement ImportStatements TypeDeclarations
            {
                $$ = node_create(NODE_FILE);
                $$->u.body[0] = $1;
                $$->u.body[1] = $2;
                $$->u.body[2] = $3;
            }
    | PackageStatement ImportStatements
            {
                $$ = node_create(NODE_FILE);
                $$->u.body[0] = $1;
                $$->u.body[1] = $2;
                $$->u.body[2] = NULL;
            }
    | PackageStatement      TypeDeclarations
            {
                $$ = node_create(NODE_FILE);
                $$->u.body[0] = $1;
                $$->u.body[1] = NULL;
                $$->u.body[2] = $2;
            }
    |      ImportStatements TypeDeclarations
            {
                $$ = node_create(NODE_FILE);
                $$->u.body[0] = NULL;
                $$->u.body[1] = $1;
                $$->u.body[2] = $2;
            }
    | PackageStatement
            {
                $$ = node_create(NODE_FILE);
                $$->u.body[0] = $1;
                $$->u.body[1] = NULL;
                $$->u.body[2] = NULL;
            }
    |      ImportStatements
            {
                $$ = node_create(NODE_FILE);
                $$->u.body[0] = NULL;
                $$->u.body[1] = $1;
                $$->u.body[2] = NULL;
            }
    |           TypeDeclarations
            {
                $$ = node_create(NODE_FILE);
                $$->u.body[0] = NULL;
                $$->u.body[1] = NULL;
                $$->u.body[2] = $1;
            }
    ;

PackageStatement
    : PACKAGE QualifiedName SemiColons
        {
            $$ = node_create(NODE_PACKAGE);
            $$->u.body[0] = $2;
        }
    ;

TypeDeclarations
    : TypeDeclarationOptSemi
                    {
                        $$ = $1;
                    }
    | TypeDeclarations TypeDeclarationOptSemi
                    {
                        $$ = $1;
                        add_to_list($1, $2);
                    }
    ;

TypeDeclarationOptSemi
    : TypeDeclaration
                    {
                        $$ = $1;
                    }
    | TypeDeclaration SemiColons
                    {
                        $$ = $1;
                    }
    ;

ImportStatements
    : ImportStatement
                {
                    $$ = $1;
                }
    | ImportStatements ImportStatement
                {
                    $$ = $1;
                    add_to_list($1, $2);
                }
    ;

ImportStatement
    : IMPORT QualifiedName SemiColons
                {
                    $$ = node_create(NODE_IMPORT);
                    $$->u.body[0] = $2;
                }
    | IMPORT QualifiedName OP_DOT OP_MULTIPLY SemiColons
                {
                    $$ = node_create(NODE_IMPORT);
                    $$->u.body[0] = $2;
                    ast_node *id = node_create(NODE_IDENTIFIER);
                    add_identifier(&(id->u.identifier), "*");
                    add_to_list($$->u.body[0], id);
                }
    ;

QualifiedName
    : IDENTIFIER    {
                        $$ = node_create(NODE_IDENTIFIER);
                        $$->u.identifier = $1;
                    }
    | QualifiedName OP_DOT IDENTIFIER
                    {
                        $$ = $1;
                        ast_node *id = node_create(NODE_IDENTIFIER);
                        id->u.identifier = $3;
                        add_to_list($1, id);
                    }
    ;

TypeDeclaration
    : ClassHeader BRACES_LEFT FieldDeclarations BRACES_RIGHT
                    {
                        $$ = node_create(NODE_CLASS);
                        $$->u.body[0] = $1;
                        $$->u.body[1] = $3;
                    }
    | ClassHeader BRACES_LEFT BRACES_RIGHT
                    {
                        $$ = node_create(NODE_CLASS);
                        $$->u.body[0] = $1;
                        $$->u.body[1] = NULL;
                    }
    ;

ClassHeader
    : Modifiers ClassWord IDENTIFIER Extends Interfaces
        {
            $$ = node_create(NODE_CLASSHEADER);
            $$->u.body[0] = $1;
            $$->u.body[1] = $2;
            ast_node *id = node_create(NODE_IDENTIFIER);
            id->u.identifier = $3;
            $$->u.body[2] = id;
            $$->u.body[3] = $4;
            $$->u.body[4] = $5;
        }
    | Modifiers ClassWord IDENTIFIER Extends
        {
            $$ = node_create(NODE_CLASSHEADER);
            $$->u.body[0] = $1;
            $$->u.body[1] = $2;
            ast_node *id = node_create(NODE_IDENTIFIER);
            id->u.identifier = $3;
            $$->u.body[2] = id;
            $$->u.body[3] = $4;
            $$->u.body[4] = NULL;
        }
    | Modifiers ClassWord IDENTIFIER       Interfaces
        {
            $$ = node_create(NODE_CLASSHEADER);
            $$->u.body[0] = $1;
            $$->u.body[1] = $2;
            ast_node *id = node_create(NODE_IDENTIFIER);
            id->u.identifier = $3;
            $$->u.body[2] = id;
            $$->u.body[3] = NULL;
            $$->u.body[4] = $4;
        }
    |       ClassWord IDENTIFIER Extends Interfaces
        {
            $$ = node_create(NODE_CLASSHEADER);
            $$->u.body[0] = NULL;
            $$->u.body[1] = $1;
            ast_node *id = node_create(NODE_IDENTIFIER);
            id->u.identifier = $2;
            $$->u.body[2] = id;
            $$->u.body[3] = $3;
            $$->u.body[4] = $4;
        }
    | Modifiers ClassWord IDENTIFIER
        {
            $$ = node_create(NODE_CLASSHEADER);
            $$->u.body[0] = $1;
            $$->u.body[1] = $2;
            ast_node *id = node_create(NODE_IDENTIFIER);
            id->u.identifier = $3;
            $$->u.body[2] = id;
            $$->u.body[3] = NULL;
            $$->u.body[4] = NULL;
        }
    |       ClassWord IDENTIFIER Extends
        {
            $$ = node_create(NODE_CLASSHEADER);
            $$->u.body[0] = NULL;
            $$->u.body[1] = $1;
            ast_node *id = node_create(NODE_IDENTIFIER);
            id->u.identifier = $2;
            $$->u.body[2] = id;
            $$->u.body[3] = $3;
            $$->u.body[4] = NULL;
        }
    |       ClassWord IDENTIFIER       Interfaces
        {
            $$ = node_create(NODE_CLASSHEADER);
            $$->u.body[0] = NULL;
            $$->u.body[1] = $1;
            ast_node *id = node_create(NODE_IDENTIFIER);
            id->u.identifier = $2;
            $$->u.body[2] = id;
            $$->u.body[3] = NULL;
            $$->u.body[4] = $3;
        }
    |       ClassWord IDENTIFIER
        {
            $$ = node_create(NODE_CLASSHEADER);
            $$->u.body[0] = NULL;
            $$->u.body[1] = $1;
            ast_node *id = node_create(NODE_IDENTIFIER);
            id->u.identifier = $2;
            $$->u.body[2] = id;
            $$->u.body[3] = NULL;
            $$->u.body[4] = NULL;
        }
    ;

Modifiers
    : Modifier
        {
            $$ = $1;
        }
    | Modifiers Modifier
        {
           $$ = $1;
           add_to_list($1, $2);
        }
    ;

Modifier
    : ABSTRACT
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "abstract");
        }
    | FINAL
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "final");
        }
    | PUBLIC
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "public");
        }
    | PROTECTED
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "protected");
        }
    | PRIVATE
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "private");
        }
    | STATIC
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "static");
        }
    | TRANSIENT
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "transient");
        }
    | VOLATILE
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "volatile");
        }
    | NATIVE
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "native");
        }
    | SYNCHRONIZED
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "synchronized");
        }
    ;

ClassWord
    : CLASS
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "class");
        }
    | INTERFACE
        {
            $$ = node_create(NODE_IDENTIFIER);
            add_identifier(&($$->u.identifier), "interface");
        }
    ;

Interfaces
    : IMPLEMENTS ClassNameList
        {
            $$ = $2;
        }
    ;

FieldDeclarations
    : FieldDeclarationOptSemi
                    {
                        $$ = $1;
                    }
    | FieldDeclarations FieldDeclarationOptSemi
                    {
                        $$ = $1;
                        add_to_list($1, $2);
                    }
    ;

FieldDeclarationOptSemi
    : FieldDeclaration
        {
            $$ = $1;
        }
    | FieldDeclaration SemiColons
        {
            $$ = $1;
        }
    ;

FieldDeclaration
    : FieldVariableDeclaration OP_SEMICOLON
        {
            $$ = node_create(NODE_FIELDDECLARATIONS);
            $$->u.body[0] = $1;
        }
    | MethodDeclaration
        {
            $$ = node_create(NODE_FIELDDECLARATIONS);
            $$->u.body[0] = $1;
        }
    | ConstructorDeclaration
        {
            $$ = node_create(NODE_FIELDDECLARATIONS);
            $$->u.body[0] = $1;
        }
    | StaticInitializer
        {
            $$ = node_create(NODE_FIELDDECLARATIONS);
            $$->u.body[0] = $1;
        }
    | NonStaticInitializer
        {
            $$ = node_create(NODE_FIELDDECLARATIONS);
            $$->u.body[0] = $1;
        }
    | TypeDeclaration
        {
            $$ = node_create(NODE_FIELDDECLARATIONS);
            $$->u.body[0] = $1;
        }
    ;

FieldVariableDeclaration
    : Modifiers TypeSpecifier VariableDeclarators
        {
            $$ = node_create(NODE_VARIABLEDECLARATION);
            $$->u.body[0] = $1;
            $$->u.body[1] = $2;
            $$->u.body[2] = $3;
        }
    |       TypeSpecifier VariableDeclarators
        {
            $$ = node_create(NODE_VARIABLEDECLARATION);
            $$->u.body[0] = NULL;
            $$->u.body[1] = $1;
            $$->u.body[2] = $2;
        }
    ;

VariableDeclarators
    : VariableDeclarator
        {
            $$ = $1;
        }
    | VariableDeclarators OP_COLON VariableDeclarator
        {
            $$ = $1;
            add_to_list($1, $3);
        }
    ;

VariableDeclarator
    : DeclaratorName
        {
            $$ = node_create(NODE_VARIABLEDECLARATOR);
            $$->u.body[0] = $1;
            $$->u.body[1] = NULL;
        }
    | DeclaratorName OP_ASSIGN VariableInitializer
        {
            $$ = node_create(NODE_VARIABLEDECLARATOR);
            $$->u.body[0] = $1;
            /* TODO: we don't care about initializers for now */
            $$->u.body[1] = NULL;
        }
    ;

VariableInitializer
    : Expression
    | BRACES_LEFT BRACES_RIGHT
    | BRACES_LEFT ArrayInitializers BRACES_RIGHT
    ;

ArrayInitializers
    : VariableInitializer
    | ArrayInitializers OP_COLON VariableInitializer
    | ArrayInitializers OP_COLON
    ;

MethodDeclaration
    : Modifiers TypeSpecifier MethodDeclarator Throws MethodBody
        {
            $$ = node_create(NODE_METHODDECLARATION);
            $$->u.body[0] = $1;
            $$->u.body[1] = $2;
            $$->u.body[2] = $3;
            $$->u.body[3] = $4;
            $$->u.body[4] = $5;
        }
    | Modifiers TypeSpecifier MethodDeclarator    MethodBody
        {
            $$ = node_create(NODE_METHODDECLARATION);
            $$->u.body[0] = $1;
            $$->u.body[1] = $2;
            $$->u.body[2] = $3;
            $$->u.body[3] = NULL;
            $$->u.body[4] = $4;
        }
    |       TypeSpecifier MethodDeclarator Throws MethodBody
        {
            $$ = node_create(NODE_METHODDECLARATION);
            $$->u.body[0] = NULL;
            $$->u.body[1] = $1;
            $$->u.body[2] = $2;
            $$->u.body[3] = $3;
            $$->u.body[4] = $4;
        }
    |       TypeSpecifier MethodDeclarator    MethodBody
        {
            $$ = node_create(NODE_METHODDECLARATION);
            $$->u.body[0] = NULL;
            $$->u.body[1] = $1;
            $$->u.body[2] = $2;
            $$->u.body[3] = NULL;
            $$->u.body[4] = $3;
        }
    ;

MethodDeclarator
    : DeclaratorName PARANTHESES_LEFT ParameterList PARANTHESES_RIGHT
        {
            $$ = node_create(NODE_METHODDECLARATOR);
            $$->u.body[0] = $1;
            $$->u.body[1] = $3;
            $$->u.body[2] = NULL;
        }
    | DeclaratorName PARANTHESES_LEFT PARANTHESES_RIGHT
        {
            $$ = node_create(NODE_METHODDECLARATOR);
            $$->u.body[0] = $1;
            $$->u.body[1] = NULL;
            $$->u.body[2] = NULL;
        }
    | MethodDeclarator OP_DIM
        {
            $$ = $1;
            if($$->u.body[2] == NULL)
            {
                $$->u.body[2] = node_create(NODE_DIM);
            }
            else
            {
                ast_node *dim = node_create(NODE_DIM);
                add_to_list($$->u.body[2], dim);
            }
        }
    ;

ParameterList
    : Parameter
        {
            $$ = $1;
        }
    | ParameterList OP_COLON Parameter
        {
            $$ = $1;
            add_to_list($1, $3);
        }
    ;

Parameter
    : TypeSpecifier DeclaratorName
        {
            $$ = node_create(NODE_PARAMETERS);
            $$->u.body[0] = NULL;
            $$->u.body[1] = $1;
            $$->u.body[2] = $2;
        }
    | FINAL TypeSpecifier DeclaratorName
        {
            $$ = node_create(NODE_PARAMETERS);
            ast_node *id = node_create(NODE_IDENTIFIER);
            add_identifier(&(id->u.identifier), "final");
            $$->u.body[0] = id;
            $$->u.body[1] = $2;
            $$->u.body[2] = $3;
        }
    ;

DeclaratorName
    : IDENTIFIER
        {
            $$ = node_create(NODE_DECLARATORNAME);
            ast_node *id = node_create(NODE_IDENTIFIER);
            id->u.identifier = $1;
            $$->u.body[0] = id;
            $$->u.body[1] = NULL;
        }
    | DeclaratorName OP_DIM
        {
            $$ = $1;
            if($$->u.body[1] == NULL)
            {
                $$->u.body[1] = node_create(NODE_DIM);
            }
            else
            {
                ast_node *dim = node_create(NODE_DIM);
                add_to_list($$->u.body[1], dim);
            }
        }
    ;

Throws
    : THROWS ClassNameList
        {
            $$ = $2;
        }
    ;

 /* for now we don't care about local variables */
MethodBody
    : Block
        {
            $$ = NULL;
        }
    | OP_SEMICOLON
        {
            $$ = NULL;
        }
    ;

/* TODO */
ConstructorDeclaration
    : Modifiers ConstructorDeclarator Throws Block
        {
            $$ = NULL;
        }
    | Modifiers ConstructorDeclarator    Block
        {
            $$ = NULL;
        }
    |       ConstructorDeclarator Throws Block
        {
            $$ = NULL;
        }
    |       ConstructorDeclarator    Block
        {
            $$ = NULL;
        }
    ;

ConstructorDeclarator
    : IDENTIFIER PARANTHESES_LEFT ParameterList PARANTHESES_RIGHT
    | IDENTIFIER PARANTHESES_LEFT PARANTHESES_RIGHT
    ;

StaticInitializer
    : STATIC Block
        {
            $$ = NULL;
        }
    ;

NonStaticInitializer
    : Block
        {
            $$ = NULL;
        }
    ;

Extends
    : EXTENDS TypeName
        {
            $$ = node_create(NODE_EXTENDS);
            $$->u.body[0] = $2;
        }
    | Extends OP_COLON TypeName
        {
            $$ = node_create(NODE_EXTENDS);
            $$->u.body[0] = $3;
        }
    ;

Block
    : BRACES_LEFT LocalVariableDeclarationsAndStatements BRACES_RIGHT
        { $$ = NULL; }
    | BRACES_LEFT BRACES_RIGHT
        { $$ = NULL; }
    ;

LocalVariableDeclarationsAndStatements
    : LocalVariableDeclarationOrStatement
    | LocalVariableDeclarationsAndStatements LocalVariableDeclarationOrStatement
    ;

LocalVariableDeclarationOrStatement
    : LocalVariableDeclarationStatement
    | Statement
    ;

LocalVariableDeclarationStatement
    : TypeSpecifier VariableDeclarators OP_SEMICOLON
        {
            /* don't need this node */
            delete_node($1);
            delete_node($2);
        }
    | FINAL TypeSpecifier VariableDeclarators OP_SEMICOLON
        {
            /* don't need these nodes */
            delete_node($2);
            delete_node($3);
        }
    ;

Statement
    : EmptyStatement
    | LabelStatement
    | ExpressionStatement OP_SEMICOLON
    | SelectionStatement
    | IterationStatement
    | JumpStatement
    | GuardingStatement
    | Block
    ;

EmptyStatement
    : OP_SEMICOLON
    ;

LabelStatement
    : IDENTIFIER OP_TERNARYBETWEEN
    | CASE ConstantExpression OP_TERNARYBETWEEN
    | DEFAULT OP_TERNARYBETWEEN
    ;

ExpressionStatement
    : Expression
    ;

SelectionStatement
    : IF PARANTHESES_LEFT Expression PARANTHESES_RIGHT Statement
    | IF PARANTHESES_LEFT Expression PARANTHESES_RIGHT Statement ELSE Statement
    | SWITCH PARANTHESES_LEFT Expression PARANTHESES_RIGHT Block
    ;

IterationStatement
    : WHILE PARANTHESES_LEFT Expression PARANTHESES_RIGHT Statement
    | DO Statement WHILE PARANTHESES_LEFT Expression PARANTHESES_RIGHT OP_SEMICOLON
    | FOR PARANTHESES_LEFT ForInit ForExpr ForIncr PARANTHESES_RIGHT Statement
    | FOR PARANTHESES_LEFT ForInit ForExpr     PARANTHESES_RIGHT Statement
    ;

ForInit
    : ExpressionStatements OP_SEMICOLON
    | LocalVariableDeclarationStatement
    | OP_SEMICOLON
    ;

ForExpr
    : Expression OP_SEMICOLON
    | OP_SEMICOLON
    ;

ForIncr
    : ExpressionStatements
    ;

ExpressionStatements
    : ExpressionStatement
    | ExpressionStatements OP_COLON ExpressionStatement
    ;

JumpStatement
    : BREAK IDENTIFIER OP_SEMICOLON
    | BREAK    OP_SEMICOLON
    | CONTINUE IDENTIFIER OP_SEMICOLON
    | CONTINUE    OP_SEMICOLON
    | RETURN Expression OP_SEMICOLON
    | RETURN    OP_SEMICOLON
    | THROW Expression OP_SEMICOLON
    ;

GuardingStatement
    : SYNCHRONIZED PARANTHESES_LEFT Expression PARANTHESES_RIGHT Statement
    | TRY Block Finally
    | TRY Block Catches
    | TRY Block Catches Finally
    ;

Catches
    : Catch
    | Catches Catch
    ;

Catch
    : CatchHeader Block
    ;

CatchHeader
    : CATCH PARANTHESES_LEFT TypeSpecifier IDENTIFIER PARANTHESES_RIGHT
    | CATCH PARANTHESES_LEFT TypeSpecifier PARANTHESES_RIGHT
    ;

Finally
    : FINALLY Block
    ;

PrimaryExpression
    : QualifiedName
        {
            /* don't need this */
            delete_node($1);
        }
    | NotJustName
    ;

NotJustName
    : SpecialName
    | NewAllocationExpression
    | ComplexPrimary
    ;

ComplexPrimary
    : PARANTHESES_LEFT Expression PARANTHESES_RIGHT
    | ComplexPrimaryNoParenthesis
    ;

ComplexPrimaryNoParenthesis
    : LITERAL_NULL
    | LITERAL_BOOLEAN
    | LITERAL_CHARACTER
    | LITERAL_FLOATING
    | LITERAL_INTEGER
    | LITERAL_STRING
    | ArrayAccess
    | FieldAccess
    | MethodCall
    ;

ArrayAccess
    : QualifiedName BRACKET_LEFT Expression BRACKET_RIGHT
        {
            /* don't need this */
            delete_node($1);
        }
    | ComplexPrimary BRACKET_LEFT Expression BRACKET_RIGHT
    ;

FieldAccess
    : NotJustName OP_DOT IDENTIFIER
    | RealPostfixExpression OP_DOT IDENTIFIER
    | QualifiedName OP_DOT THIS
        {
            /* don't need this */
            delete_node($1);
        }
    | QualifiedName OP_DOT CLASS
        {
            /* don't need this */
            delete_node($1);
        }
    | PrimitiveType OP_DOT CLASS
    ;

MethodCall
    : MethodAccess PARANTHESES_LEFT ArgumentList PARANTHESES_RIGHT
    | MethodAccess PARANTHESES_LEFT PARANTHESES_RIGHT
    ;

MethodAccess
    : ComplexPrimaryNoParenthesis
    | SpecialName
    | QualifiedName
        {
            /* don't need this */
            delete_node($1);
        }
    ;

SpecialName
    : THIS
    | SUPER
    ;

ArgumentList
    : Expression
    | ArgumentList OP_COLON Expression
    ;

NewAllocationExpression
    : PlainNewAllocationExpression
    | QualifiedName OP_DOT PlainNewAllocationExpression
        {
            /* don't need this */
            delete_node($1);
        }
    ;

PlainNewAllocationExpression
    : ArrayAllocationExpression
    | ClassAllocationExpression
    | ArrayAllocationExpression BRACES_LEFT BRACES_RIGHT
    | ClassAllocationExpression BRACES_LEFT BRACES_RIGHT
    | ArrayAllocationExpression BRACES_LEFT ArrayInitializers BRACES_RIGHT
    | ClassAllocationExpression BRACES_LEFT FieldDeclarations BRACES_RIGHT
        {
            /* don't need this field declarations */
            delete_node($3);
        }
    ;

ClassAllocationExpression
    : NEW TypeName PARANTHESES_LEFT ArgumentList PARANTHESES_RIGHT
    | NEW TypeName PARANTHESES_LEFT      PARANTHESES_RIGHT
    ;

ArrayAllocationExpression
    : NEW TypeName DimExprs Dims
        {
            /* don't need these */
            delete_node($2);
            delete_node($4);
        }
    | NEW TypeName DimExprs
    | NEW TypeName Dims
        {
            /* don't need these */
            delete_node($2);
            delete_node($3);
        }
    ;

DimExprs
    : DimExpr
    | DimExprs DimExpr
    ;

DimExpr
    : BRACKET_LEFT Expression BRACKET_RIGHT
    ;

Dims
    : OP_DIM
        {
            $$ = node_create(NODE_DIM); 
            printf("Dims1 %p\n",$$);
        }
    | Dims OP_DIM
        {
            $$ = $1;
            ast_node *dim = node_create(NODE_DIM);
            add_to_list($1, dim);
            printf("Dims2 %p\n",$$->u.body[2]);
        }
    ;

PostfixExpression
    : PrimaryExpression
    | RealPostfixExpression
    ;

RealPostfixExpression
    : PostfixExpression OP_INCREMENT
    | PostfixExpression OP_DECREMENT
    ;

UnaryExpression
    : OP_INCREMENT UnaryExpression
    | OP_DECREMENT UnaryExpression
    | ArithmeticUnaryOperator CastExpression
    | LogicalUnaryExpression
    ;

LogicalUnaryExpression
    : PostfixExpression
    | LogicalUnaryOperator UnaryExpression
    ;

LogicalUnaryOperator
    : OP_BITWISENOT
    | OP_NOT
    ;

ArithmeticUnaryOperator
    : OP_PLUS
    | OP_MINUS
    ;

CastExpression
    : UnaryExpression
    | PARANTHESES_LEFT PrimitiveTypeExpression PARANTHESES_RIGHT CastExpression
    | PARANTHESES_LEFT ClassTypeExpression PARANTHESES_RIGHT CastExpression
    | PARANTHESES_LEFT Expression PARANTHESES_RIGHT LogicalUnaryExpression
    ;

PrimitiveTypeExpression
    : PrimitiveType
    | PrimitiveType Dims
        {
            /* don't need this */
            delete_node($2);
        }
    ;

ClassTypeExpression
    : QualifiedName Dims
        {
            /* don't need this */
            delete_node($2);
        }
    ;

MultiplicativeExpression
    : CastExpression
    | MultiplicativeExpression OP_MULTIPLY CastExpression
    | MultiplicativeExpression OP_DIVIDE CastExpression
    | MultiplicativeExpression OP_REMAINDER CastExpression
    ;

AdditiveExpression
    : MultiplicativeExpression
    | AdditiveExpression OP_PLUS MultiplicativeExpression
    | AdditiveExpression OP_MINUS MultiplicativeExpression
    ;

ShiftExpression
    : AdditiveExpression
    | ShiftExpression OP_SHIFTLEFT AdditiveExpression
    | ShiftExpression OP_SHIFTRIGHT AdditiveExpression
    | ShiftExpression OP_UNSIGNEDSHIFTRIGHT AdditiveExpression
    ;

RelationalExpression
    : ShiftExpression
    | RelationalExpression OP_LESSTHAN ShiftExpression
    | RelationalExpression OP_GREATERTHAN ShiftExpression
    | RelationalExpression OP_LESSTHANOREQUAL ShiftExpression
    | RelationalExpression OP_GREATERTHANOREQUAL ShiftExpression
    | RelationalExpression OP_INSTANCEOF TypeSpecifier
    ;

EqualityExpression
    : RelationalExpression
    | EqualityExpression OP_EQUAL RelationalExpression
    | EqualityExpression OP_NOTEQUAL RelationalExpression
    ;

AndExpression
    : EqualityExpression
    | AndExpression OP_BITWISEAND EqualityExpression
    ;

ExclusiveOrExpression
    : AndExpression
    | ExclusiveOrExpression OP_BITWISEXOR AndExpression
    ;

InclusiveOrExpression
    : ExclusiveOrExpression
    | InclusiveOrExpression OP_BITWISEOR ExclusiveOrExpression
    ;

ConditionalAndExpression
    : InclusiveOrExpression
    | ConditionalAndExpression OP_LOGICALAND InclusiveOrExpression
    ;

ConditionalOrExpression
    : ConditionalAndExpression
    | ConditionalOrExpression OP_LOGICALOR ConditionalAndExpression
    ;

ConditionalExpression
    : ConditionalOrExpression
    | ConditionalOrExpression OP_TERNARYBEGIN Expression OP_TERNARYBETWEEN ConditionalExpression
    ;

AssignmentExpression
    : ConditionalExpression
    | UnaryExpression AssignmentOperator AssignmentExpression
    ;

AssignmentOperator
    : OP_ASSIGN
    | OP_ASSIGNMULTIPLY
    | OP_ASSIGNDIVIDE
    | OP_ASSIGNREMAINDER
    | OP_ASSIGNADD
    | OP_ASSIGNSUBTRACT
    | OP_SHIFTLEFT
    | OP_SHIFTRIGHT
    | OP_UNSIGNEDSHIFTRIGHT
    | OP_ASSIGNBITWISEAND
    | OP_ASSIGNBITWISEXOR
    | OP_ASSIGNBITWISEOR
    ;

Expression
    : AssignmentExpression
    ;

ConstantExpression
    : ConditionalExpression
    ;

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
    exit(1); // for now no recovery.
}

