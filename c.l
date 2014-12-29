%e  1019
%p  2807
%n  371
%k  284
%a  1213
%o  1117

O   [0-7]
D   [0-9]
NZ  [1-9]
L   [a-zA-Z_]
A   [a-zA-Z_0-9]
H   [a-fA-F0-9]
HP  (0[xX])
E   ([Ee][+-]?{D}+)
P   ([Pp][+-]?{D}+)
FS  (f|F|l|L)
IS  (((u|U)(l|L|ll|LL)?)|((l|L|ll|LL)(u|U)?))
CP  (u|U|L)
SP  (u8|u|U|L)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\n\f]

%{
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include "pub.h"
#include "c.tab.h"

extern void yyerror(const char *);  /* prints grammar violation message */

extern int sym_type(const char *);  /* returns type from symbol table */

#define sym_type(identifier) IDENTIFIER /* with no symbol table, fake it */

static void comment(void);
static int check_type(void);
%}

%%
"/*"                                    { comment(); }
"//".*                                    { /* consume //-comment */ }

"auto"					{ newNode(yytext,0); return(AUTO); }
"break"					{ newNode(yytext,0); return(BREAK); }
"case"					{ newNode(yytext,0); return(CASE); }
"char"					{ newNode(yytext,0); return(CHAR); }
"const"					{ newNode(yytext,0); return(CONST); }
"continue"				{ newNode(yytext,0); return(CONTINUE); }
"default"				{ newNode(yytext,0); return(DEFAULT); }
"do"					{ newNode(yytext,0); return(DO); }
"double"				{ newNode(yytext,0); return(DOUBLE); }
"else"					{ newNode(yytext,0); return(ELSE); }
"enum"					{ newNode(yytext,0); return(ENUM); }
"extern"				{ newNode(yytext,0); return(EXTERN); }
"float"					{ newNode(yytext,0); return(FLOAT); }
"for"					{ newNode(yytext,0); return(FOR); }
"goto"					{ newNode(yytext,0); return(GOTO); }
"if"					{ newNode(yytext,0); return(IF); }
"inline"				{ newNode(yytext,0); return(INLINE); }
"int"					{ newNode(yytext,0); return(INT); }
"long"					{ newNode(yytext,0); return(LONG); }
"register"				{ newNode(yytext,0); return(REGISTER); }
"restrict"				{ newNode(yytext,0); return(RESTRICT); }
"return"				{ newNode(yytext,0); return(RETURN); }
"short"					{ newNode(yytext,0); return(SHORT); }
"signed"				{ newNode(yytext,0); return(SIGNED); }
"sizeof"				{ newNode(yytext,0); return(SIZEOF); }
"static"				{ newNode(yytext,0); return(STATIC); }
"struct"				{ newNode(yytext,0); return(STRUCT); }
"switch"				{ newNode(yytext,0); return(SWITCH); }
"typedef"				{ newNode(yytext,0); return(TYPEDEF); }
"union"					{ newNode(yytext,0); return(UNION); }
"unsigned"				{ newNode(yytext,0); return(UNSIGNED); }
"void"					{ newNode(yytext,0); return(VOID); }
"volatile"				{ newNode(yytext,0); return(VOLATILE); }
"while"					{ newNode(yytext,0); return(WHILE); }
"_Alignas"                              { newNode(yytext,0); return ALIGNAS; }
"_Alignof"                              { newNode(yytext,0); return ALIGNOF; }
"_Atomic"                               { newNode(yytext,0); return ATOMIC; }
"_Bool"                                 { newNode(yytext,0); return BOOL; }
"_Complex"                              { newNode(yytext,0); return COMPLEX; }
"_Generic"                              { newNode(yytext,0); return GENERIC; }
"_Imaginary"                            { newNode(yytext,0); return IMAGINARY; }
"_Noreturn"                             { newNode(yytext,0); return NORETURN; }
"_Static_assert"                        { newNode(yytext,0); return STATIC_ASSERT; }
"_Thread_local"                         { newNode(yytext,0); return THREAD_LOCAL; }
"__func__"                              { newNode(yytext,0); return FUNC_NAME; }

{L}{A}*					{ newNode(yytext,0); return check_type(); }

{HP}{H}+{IS}?				{ newNode(yytext,0); return I_CONSTANT; }
{NZ}{D}*{IS}?				{ newNode(yytext,0); return I_CONSTANT; }
"0"{O}*{IS}?				{ newNode(yytext,0); return I_CONSTANT; }
{CP}?"'"([^'\\\n]|{ES})+"'"		{ newNode(yytext,0); return I_CONSTANT; }

{D}+{E}{FS}?				{ newNode(yytext,0); return F_CONSTANT; }
{D}*"."{D}+{E}?{FS}?			{ newNode(yytext,0); return F_CONSTANT; }
{D}+"."{E}?{FS}?			{ newNode(yytext,0); return F_CONSTANT; }
{HP}{H}+{P}{FS}?			{ newNode(yytext,0); return F_CONSTANT; }
{HP}{H}*"."{H}+{P}{FS}?			{ newNode(yytext,0); return F_CONSTANT; }
{HP}{H}+"."{P}{FS}?			{ newNode(yytext,0); return F_CONSTANT; }

({SP}?\"([^"\\\n]|{ES})*\"{WS}*)+	{ newNode(yytext,0); return STRING_LITERAL; }

"..."					{ newNode(yytext,0); return ELLIPSIS; }
">>="					{ newNode(yytext,0); return RIGHT_ASSIGN; }
"<<="					{ newNode(yytext,0); return LEFT_ASSIGN; }
"+="					{ newNode(yytext,0); return ADD_ASSIGN; }
"-="					{ newNode(yytext,0); return SUB_ASSIGN; }
"*="					{ newNode(yytext,0); return MUL_ASSIGN; }
"/="					{ newNode(yytext,0); return DIV_ASSIGN; }
"%="					{ newNode(yytext,0); return MOD_ASSIGN; }
"&="					{ newNode(yytext,0); return AND_ASSIGN; }
"^="					{ newNode(yytext,0); return XOR_ASSIGN; }
"|="					{ newNode(yytext,0); return OR_ASSIGN; }
">>"					{ newNode(yytext,0); return RIGHT_OP; }
"<<"					{ newNode(yytext,0); return LEFT_OP; }
"++"					{ newNode(yytext,0); return INC_OP; }
"--"					{ newNode(yytext,0); return DEC_OP; }
"->"					{ newNode(yytext,0); return PTR_OP; }
"&&"					{ newNode(yytext,0); return AND_OP; }
"||"					{ newNode(yytext,0); return OR_OP; }
"<="					{ newNode(yytext,0); return LE_OP; }
">="					{ newNode(yytext,0); return GE_OP; }
"=="					{ newNode(yytext,0); return EQ_OP; }
"!="					{ newNode(yytext,0); return NE_OP; }
";"					{ newNode(yytext,0); return ';'; }
("{"|"<%")				{ newNode(yytext,0); return '{'; }
("}"|"%>")				{ newNode(yytext,0); return '}'; }
","					{ newNode(yytext,0); return ','; }
":"					{ newNode(yytext,0); return ':'; }
"="					{ newNode(yytext,0); return '='; }
"("					{ newNode(yytext,0); return '('; }
")"					{ newNode(yytext,0); return ')'; }
("["|"<:")				{ newNode(yytext,0); return '['; }
("]"|":>")				{ newNode(yytext,0); return ']'; }
"."					{ newNode(yytext,0); return '.'; }
"&"					{ newNode(yytext,0); return '&'; }
"!"					{ newNode(yytext,0); return '!'; }
"~"					{ newNode(yytext,0); return '~'; }
"-"					{ newNode(yytext,0); return '-'; }
"+"					{ newNode(yytext,0); return '+'; }
"*"					{ newNode(yytext,0); return '*'; }
"/"					{ newNode(yytext,0); return '/'; }
"%"					{ newNode(yytext,0); return '%'; }
"<"					{ newNode(yytext,0); return '<'; }
">"					{ newNode(yytext,0); return '>'; }
"^"					{ newNode(yytext,0); return '^'; }
"|"					{ newNode(yytext,0); return '|'; }
"?"					{ newNode(yytext,0); return '?'; }

{WS}					{ /* whitespace separates tokens */ }
.					{ /* discard bad characters */ }

%%

int yywrap(void)        /* called at end of input */
{
    return 1;           /* terminate now */
}

static void comment(void)
{
    int c;

    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
                return;

            if (c == 0)
                break;
        }
    yyerror("unterminated comment");
}


void yyerror(const char *s)
{
        fflush(stdout);
        fprintf(stderr, "*** %s\n", s);
}





static int check_type(void)
{
    switch (sym_type(yytext))
    {
    case TYPEDEF_NAME:                /* previously defined */
        return TYPEDEF_NAME;
    case ENUMERATION_CONSTANT:        /* previously defined */
        return ENUMERATION_CONSTANT;
    default:                          /* includes undefined */
        return IDENTIFIER;
    }
}
