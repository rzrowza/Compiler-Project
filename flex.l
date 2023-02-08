%{
    #include<stdio.h>
    #include<string.h>
    #include<math.h>
    #include "bison.h"
%}



alpha   [a-zA-Z]+

%%
"keyword"   {return KEYWORD;}
"int"       {return INT;}
"float"     {return FLOAT;}
"char"      {return CHAR;}
";"         {return SEMICOLON;}
"{"         {return LC;}
"}"         {return RC;}



{alpha}     {yylval  = *yytext - 'a'; return	VAR;} 

[ ]*	    			                                {}
[,:]     												{ return *yytext;	}
[\n]*					                                {}
[\t]*					                                {}
.						                                {printf("%s --> invalid\n",yytext);}
%%