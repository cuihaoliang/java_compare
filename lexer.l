/*
 *  lexer file for java (probably incomplete) part of java_compare
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
#include <string.h>
#include <stdlib.h>

#include "integer_floating.h"
#include "parser.h"

static void yyunput (int c, register char * yy_bp ) __attribute__((unused));
static int input  (void) __attribute__((unused));

extern void yyerror(const char *msg);
%}

%option yylineno

%x COMMENT_MULTILINE COMMENT

integer                     [0-9]+
hexadecimal                 [0-9a-fA-F]+
binary                      [0-1]+
floating                    [0-9]*\.[0-9]+
string                      \"(\\.|[^"])*\"
character                   \'(\\.|[^'])*\'
identifier                  [a-zA-Z_][a-zA-Z0-9_]*

%%

 /* keywords */
"abstract"                  return ABSTRACT;
"contine"                   return CONTINUE;
"for"                       return FOR;
"new"                       return NEW;
"switch"                    return SWITCH;
"assert"                    return ASSERT;
"default"                   return DEFAULT;
"goto"                      return GOTO;
"package"                   return PACKAGE;
"synchronized"              return SYNCHRONIZED;
"do"                        return DO;
"if"                        return IF;
"private"                   return PRIVATE;
"this"                      return THIS;
"break"                     return BREAK;
"implements"                return IMPLEMENTS;
"protected"                 return PROTECTED;
"throw"                     return THROW;
"else"                      return ELSE;
"import"                    return IMPORT;
"public"                    return PUBLIC;
"throws"                    return THROWS;
"case"                      return CASE;
"enum"                      return ENUM;
"return"                    return RETURN;
"transient"                 return TRANSIENT;
"catch"                     return CATCH;
"extends"                   return EXTENDS;
"try"                       return TRY;
"final"                     return FINAL;
"interface"                 return INTERFACE;
"static"                    return STATIC;
"void"                      return VOID;
"class"                     return CLASS;
"finally"                   return FINALLY;
"strictfp"                  return STRICTFP;
"volatile"                  return VOLATILE;
"const"                     return CONST;
"native"                    return NATIVE;
"super"                     return SUPER;
"while"                     return WHILE;

 /* comments */
"/*"                        BEGIN(COMMENT_MULTILINE);
<COMMENT_MULTILINE>"*/"     BEGIN(INITIAL);
<COMMENT_MULTILINE>\r?\n    ;
<COMMENT_MULTILINE><<EOF>>  yyerror("reached EOF within multiline comment");
<COMMENT_MULTILINE>.        ;

"//"                        BEGIN(COMMENT);
<COMMENT>\r?\n              BEGIN(INITIAL);
<COMMENT><<EOF>>            {
                                BEGIN(INITIAL);
                                return _EOF;
                            }
<COMMENT>.                  ;

 /* operators */
"instanceof"                return OP_INSTANCEOF;
"="                         return OP_ASSIGN;
"+"                         return OP_PLUS;
"-"                         return OP_MINUS;
"*"                         return OP_MULTIPLY;
"/"                         return OP_DIVIDE;
"%"                         return OP_REMAINDER;
"++"                        return OP_INCREMENT;
"--"                        return OP_DECREMENT;
"!"                         return OP_NOT;
"=="                        return OP_EQUAL;
"!="                        return OP_NOTEQUAL;
">"                         return OP_GREATER;
">="                        return OP_GREATEROREQUAL;
"<"                         return OP_LESS;
"<="                        return OP_LESSOREQUAL;
"&&"                        return OP_LOGICALAND;
"||"                        return OP_LOGICALOR;
"?"                         return OP_TERNARYBEGIN;
":"                         return OP_TERNARYBETWEEN;
"~"                         return OP_BITWISENOT;
"<<"                        return OP_SHIFTLEFT;
">>"                        return OP_SHIFTRIGHT;
">>>"                       return OP_UNSIGNEDSHIFTRIGHT;
"&"                         return OP_BITWISEAND;
"^"                         return OP_BITWISEXOR;
"|"                         return OP_BITWISEOR;

 /* parantheses */
"("                         return PARANTHESES_LEFT;
")"                         return PARANTHESES_RIGHT;
"\["                        return BRACKET_LEFT;
"\]"                        return BRACKET_RIGHT;
"\{"                        return BRACES_LEFT;
"\}"                        return BRACES_RIGHT;

 /* data types */
"byte"                      return TYPE_BYTE;
"short"                     return TYPE_SHORT;
"int"                       return TYPE_INT;
"long"                      return TYPE_LONG;
"float"                     return TYPE_FLOAT;
"double"                    return TYPE_DOUBLE;
"boolean"                   return TYPE_BOOLEAN;
"char"                      return TYPE_CHAR;

 /* literals */
 /* TODO: underscore within integer/floating literals */
"null"                      return LITERAL_NULL;
{integer}                   {
                                yylval.integer.value = atoi(yytext);
                                yylval.integer.type = INTEGER_TYPE_INTEGER;
                                return LITERAL_INTEGER;
                            }
"0b"{binary}                {
                                yylval.integer.value = strtol(yytext+2, NULL, 2);
                                yylval.integer.type = INTEGER_TYPE_INTEGER;
                                return LITERAL_INTEGER;
                            }
"0x"{hexadecimal}           {
                                yylval.integer.value = strtol(yytext+2, NULL, 16);
                                yylval.integer.type = INTEGER_TYPE_INTEGER;
                                return LITERAL_INTEGER;
                            }
{integer}("l"|"L")          {
                                yylval.integer.value = atoi(yytext);
                                yylval.integer.type = INTEGER_TYPE_LONG;
                                return LITERAL_INTEGER;
                            }
"0b"{binary}("l"|"L")       {
                                yylval.integer.value = strtol(yytext+2, NULL, 2);
                                yylval.integer.type = INTEGER_TYPE_LONG;
                                return LITERAL_INTEGER;
                            }
"0x"{hexadecimal}("l"|"L")  {
                                yylval.integer.value = strtol(yytext+2, NULL, 16);
                                yylval.integer.type = INTEGER_TYPE_LONG;
                                return LITERAL_INTEGER;
                            }
{floating}("f"|"F")         {
                                yylval.floating.value = atof(yytext);
                                yylval.floating.type = FLOATING_TYPE_FLOAT;
                                return LITERAL_FLOATING;
                            }
{floating}("d"|"D")         {
                                yylval.floating.value = atof(yytext);
                                yylval.floating.type = FLOATING_TYPE_DOUBLE;
                                return LITERAL_FLOATING;
                            }
 /* scientific double */
{floating}"e"{integer}      {
                                yylval.floating.value = atof(yytext);
                                yylval.floating.type = FLOATING_TYPE_DOUBLE;
                                return LITERAL_FLOATING;
                            }
{floating}                  {
                                yylval.floating.value = atof(yytext);
                                yylval.floating.type = FLOATING_TYPE_DOUBLE;
                                return LITERAL_FLOATING;
                            }
{string}                    {
                                yylval.string = strdup(yytext);
                                return LITERAL_STRING;
                            }
{character}                 {
                                /* TODO: ex: \u3434 */
                                yylval.character = yytext[1];
                                return LITERAL_CHARACTER;
                            }
"true"                      return LITERAL_TRUE;
"false"                     return LITERAL_FALSE;

 /* identifier */
{identifier}                return IDENTIFIER;

<<EOF>>                     return _EOF;

.                           yyerror("syntax error");
%%

