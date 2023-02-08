%{
    
    #include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	#include<string.h>
	#include<stdarg.h>
   
    int sym[26] ;   
    int yylex();
	extern FILE *yyin,*yyout;
    void yyerror(char *s);
    int i  = 0; 
    int f  = 0;
    int c  = 0;
    int v  = 0;
%}

%token  KEYWORD INT FLOAT CHAR SEMICOLON LC RC VAR


%start program

%%
program : KEYWORD LC declaration RC {
    printf("vairbale %d\n",v) ;
    printf("int %d\n",i) ;
    printf("float %d\n",f) ;
    printf("char %d\n",c) } ;

declaration: TYPE VAR SEMICOLON declaration | 
            

TYPE : INT {++i ; ++v ;}
    | FLOAT {++f ; ++v ;}
    | CHAR  {++c ; ++v ;}
    ;


%%

void yyerror(char *s){
	printf( "%s\n", s);
}

int yywrap()
{
	return 1;
}

int main() {

    freopen("input.txt","r",stdin);
    freopen("output.txt","w",stdout);
    

    yyparse();
    return 0;
}