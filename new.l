%{
#include "new.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern FILE *yyout;

%}

ID [a-zA-Z][a-zA-Z0-9]*[_]?[a-zA-Z0-9]*
DIGIT [0-9]
header					"import"[ ]*+[^\n]+[.h][ ]*
comment  [/][*](.*|\n)*[*][/]|[/][/](.*|\n) 

%%
{comment} {
	            printf("\nComment detected\n");
				}
"int"               { return INT; }
"float"             { return FLOAT;}
"main"		{return START;}
"string"            {return STRING;}
"if"    {return IF;}
"elseif" {return ELIF;}
"else"    {return ELSE;}
"loop"    {return FOR;}
"while" {return WHILE;}
"fact"  	   {return FACT;}
"leapyear"      {return LEAPYEAR;}
":"             { return COLON; }
"switch"        { return SWITCH;}
"default"       { return DEFAULT;}
"output"		    { return VALUE;}
"++"            { return UP;}
"--"          { return DOWN;}
"case"          { return CASE;}
"stop"         {return BREAK;}
"dec"             {return DEC;}
"sqrt"            {return SQRT;}
"gcd"              {return GCD;}
"lcm"               {return LCM;}
"max"           {return MAX;}
"min"               {return MIN;}
"exchange"          {return EXCNG;}
[[]        { return '['; }
[]]        { return ']'; }
[{]        { return '{'; }
[}]        { return '}'; }
[(]        { return '('; }
[)]        { return ')'; }
[;]        { return END;}


"="      {return '=';}
"+"      {return '+';}
"-"      {return '-';}
"*"      {return '*'; }
"/"      {return '/';}
"^"     {return '^'; }
"%"      {return '%'; }
"inc"    {return INC;}
"dec"     {return DEC;}
"stop"  {return BREAK;}
"=="    {return ASSIGN;}
"<"      {return LT;}
">"      {return GT;}
"<="    {return LTEQ;}
">="    {return GTEQ;}
"!="    {return NEQ;} 
"&&"   {return AND;}
"||"    {return OR;} 
","      {return ',';}
[ \n\t]*	   

\"(\\.|[^"\\])*\" {yylval.ch = strdup(yytext);return STRING;}

[+-]?[0-9]*[.][0-9]+([eE][+-]?[0-9]+)? {yylval.floating = atof(yytext); return DOUBLE;}

"#include" { return IMPORT; }
{ID}".h" { return HEADER; }

{ID} {
			yylval.ch = strdup(yytext);
 			return VARIABLE;
 			}

"-"?{DIGIT}+ {
	yylval.num=atoi(yytext);
	return NUMBER;
	}

"-"?{DIGIT}+?"."{DIGIT}+ {
	yylval.num=atoi(yytext);
	return NUMBER;
	}



%%

int yywrap()
{
	return 1;
}

int main()
{
	yyin = freopen("input.txt","r",stdin);
	yyout = freopen("output.txt","w",stdout);
	yyparse();

}
