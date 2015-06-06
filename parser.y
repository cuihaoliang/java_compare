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
    int boolean;

    /* TODO */
    void *node;
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
    | TypeName Dims
    ;

TypeName
    : PrimitiveType
    | QualifiedName
    ;

ClassNameList
    : QualifiedName
    | ClassNameList OP_COLON QualifiedName
    ;

PrimitiveType
    : TYPE_BOOLEAN
    | TYPE_CHAR
    | TYPE_BYTE
    | TYPE_SHORT
    | TYPE_INT
    | TYPE_LONG
    | TYPE_FLOAT
    | TYPE_DOUBLE
    | VOID
    ;

SemiColons
    : OP_SEMICOLON
    | SemiColons OP_SEMICOLON
    ;

CompilationUnit
    : ProgramFile
    ;

ProgramFile
    : PackageStatement ImportStatements TypeDeclarations
    | PackageStatement ImportStatements
    | PackageStatement      TypeDeclarations
    |      ImportStatements TypeDeclarations
    | PackageStatement
    |      ImportStatements
    |           TypeDeclarations
    ;

PackageStatement
    : PACKAGE QualifiedName SemiColons
    ;

TypeDeclarations
    : TypeDeclarationOptSemi
    | TypeDeclarations TypeDeclarationOptSemi
    ;

TypeDeclarationOptSemi
    : TypeDeclaration
    | TypeDeclaration SemiColons
    ;

ImportStatements
    : ImportStatement
    | ImportStatements ImportStatement
    ;

ImportStatement
    : IMPORT QualifiedName SemiColons
    | IMPORT QualifiedName OP_DOT OP_MULTIPLY SemiColons
    ;

QualifiedName
    : IDENTIFIER
    | QualifiedName OP_DOT IDENTIFIER
    ;

TypeDeclaration
    : ClassHeader BRACES_LEFT FieldDeclarations BRACES_RIGHT
    | ClassHeader BRACES_LEFT BRACES_RIGHT
    ;

ClassHeader
    : Modifiers ClassWord IDENTIFIER Extends Interfaces
    | Modifiers ClassWord IDENTIFIER Extends
    | Modifiers ClassWord IDENTIFIER       Interfaces
    |       ClassWord IDENTIFIER Extends Interfaces
    | Modifiers ClassWord IDENTIFIER
    |       ClassWord IDENTIFIER Extends
    |       ClassWord IDENTIFIER       Interfaces
    |       ClassWord IDENTIFIER
    ;

Modifiers
    : Modifier
    | Modifiers Modifier
    ;

Modifier
    : ABSTRACT
    | FINAL
    | PUBLIC
    | PROTECTED
    | PRIVATE
    | STATIC
    | TRANSIENT
    | VOLATILE
    | NATIVE
    | SYNCHRONIZED
    ;

ClassWord
    : CLASS
    | INTERFACE
    ;

Interfaces
    : IMPLEMENTS ClassNameList
    ;

FieldDeclarations
    : FieldDeclarationOptSemi
    | FieldDeclarations FieldDeclarationOptSemi
    ;

FieldDeclarationOptSemi
    : FieldDeclaration
    | FieldDeclaration SemiColons
    ;

FieldDeclaration
    : FieldVariableDeclaration OP_SEMICOLON
    | MethodDeclaration
    | ConstructorDeclaration
    | StaticInitializer
    | NonStaticInitializer
    | TypeDeclaration
    ;

FieldVariableDeclaration
    : Modifiers TypeSpecifier VariableDeclarators
    |       TypeSpecifier VariableDeclarators
    ;

VariableDeclarators
    : VariableDeclarator
    | VariableDeclarators OP_COLON VariableDeclarator
    ;

VariableDeclarator
    : DeclaratorName
    | DeclaratorName OP_ASSIGN VariableInitializer
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
    | Modifiers TypeSpecifier MethodDeclarator    MethodBody
    |       TypeSpecifier MethodDeclarator Throws MethodBody
    |       TypeSpecifier MethodDeclarator    MethodBody
    ;

MethodDeclarator
    : DeclaratorName PARANTHESES_LEFT ParameterList PARANTHESES_RIGHT
    | DeclaratorName PARANTHESES_LEFT PARANTHESES_RIGHT
    | MethodDeclarator OP_DIM
    ;

ParameterList
    : Parameter
    | ParameterList OP_COLON Parameter
    ;

Parameter
    : TypeSpecifier DeclaratorName
    | FINAL TypeSpecifier DeclaratorName
    ;

DeclaratorName
    : IDENTIFIER
    | DeclaratorName OP_DIM
    ;

Throws
    : THROWS ClassNameList
    ;

MethodBody
    : Block
    | OP_SEMICOLON
    ;

ConstructorDeclaration
    : Modifiers ConstructorDeclarator Throws Block
    | Modifiers ConstructorDeclarator    Block
    |       ConstructorDeclarator Throws Block
    |       ConstructorDeclarator    Block
    ;

ConstructorDeclarator
    : IDENTIFIER PARANTHESES_LEFT ParameterList PARANTHESES_RIGHT
    | IDENTIFIER PARANTHESES_LEFT PARANTHESES_RIGHT
    ;

StaticInitializer
    : STATIC Block
    ;

NonStaticInitializer
    : Block
    ;

Extends
    : EXTENDS TypeName
    | Extends OP_COLON TypeName
    ;

Block
    : BRACES_LEFT LocalVariableDeclarationsAndStatements BRACES_RIGHT
    | BRACES_LEFT BRACES_RIGHT
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
    | FINAL TypeSpecifier VariableDeclarators OP_SEMICOLON
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
    | ComplexPrimary BRACKET_LEFT Expression BRACKET_RIGHT
    ;

FieldAccess
    : NotJustName OP_DOT IDENTIFIER
    | RealPostfixExpression OP_DOT IDENTIFIER
    | QualifiedName OP_DOT THIS
    | QualifiedName OP_DOT CLASS
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
    ;

PlainNewAllocationExpression
    : ArrayAllocationExpression
    | ClassAllocationExpression
    | ArrayAllocationExpression BRACES_LEFT BRACES_RIGHT
    | ClassAllocationExpression BRACES_LEFT BRACES_RIGHT
    | ArrayAllocationExpression BRACES_LEFT ArrayInitializers BRACES_RIGHT
    | ClassAllocationExpression BRACES_LEFT FieldDeclarations BRACES_RIGHT
    ;

ClassAllocationExpression
    : NEW TypeName PARANTHESES_LEFT ArgumentList PARANTHESES_RIGHT
    | NEW TypeName PARANTHESES_LEFT      PARANTHESES_RIGHT
    ;

ArrayAllocationExpression
    : NEW TypeName DimExprs Dims
    | NEW TypeName DimExprs
    | NEW TypeName Dims
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
    | Dims OP_DIM
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
    ;

ClassTypeExpression
    : QualifiedName Dims
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

