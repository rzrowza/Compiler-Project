%{
#include<stdio.h>
#include <math.h>
#include<stdlib.h>
#include<string.h>

    char variable[1000][1000];
    int store[1000];
	int last_point = 1,f=1;
	int cdefault=0,var=0;
	char param[100][100];
	int cnt_func = 1;
	int conditionMatched;
    int func_here(char *s){
 		int i;
        for(i=1; i<cnt_func; i++){
            if(strcmp(param[i],s) == 0)return 1;
        }return 0;
	}

    int assign_func(char *s)
    {
        strcpy(param[cnt_func],s); cnt_func++;return 1;
    }


    int isdeclared(char *s){
        int i;
        for(i=1; i<last_point; i++){
            if(strcmp(variable[i],s) == 0)return 1;
        }return 0;
    }
    
    int assign(char *s)
    {
        if(isdeclared(s)==1)
            return 0;
        strcpy(variable[last_point],s); store[last_point]=0;last_point++;return 1;
    }

    int setval(char *s,int val)
    {
        if(isdeclared(s) == 0)
            return 0;
        int ok=0, i;
        for( i=1; i<last_point; i++)
        {
            if(strcmp(variable[i],s) == 0)
            {
                ok=i;
                break;
            }
        }
        store[ok]=val;
        return 1;
    }

    int getval(char *s)
    {

        int indx=-1;
        int i;
        for( i=1; i<last_point; i++)
        {
            if(strcmp(variable[i],s) == 0)
            {
               indx=i;
                break;
            }
        }
        return indx;
    }
    
%}

%union
{
    char *ch;
    int num;
	double floating;
}
%token <num>  NUMBER
%token <ch>  VARIABLE
%type  <num>  expression
%type  <num>  then
%type  <num> codes
%type  <num> param
%type<num>if_block
%type<num>single_elif
%type<num>single_else
%error-verbose /* shows syntax error. */
%debug 
%token INT EXCNG FLOAT CHARACTER IF LEAPYEAR ELSE ELIF FOR PF ENDED COLON SWITCH DEFAULT VALUE ASSIGN INC DEC LT GT EQ  GTEQ LTEQ NEQ START UP DOWN CASE WHILE STRING DOUBLE HEADER IMPORT DECIMAL FACT BREAK SQRT GCD LCM  MAX MIN AND OR END
%nonassoc ELIF
%nonassoc ELSE
%left LT GT EQ  GTEQ LTEQ
%left '+' '-'
%left '*' '/'
%left '^'

%%
program:
        import func type START '{' lines '}'  {printf("\nProgram successfully ended\n");}
        | /* NULL */
        ;

import: IMPORT LT HEADER GT { printf("\nHeader File is Found\n"); }
		| /*empty*/
		import IMPORT LT HEADER GT { printf("\nHeader File is Found\n"); }
		;



func: type VARIABLE '(' param ')' '{' lines '}'
	{
		printf("\nFunction is declared\n");		
	};



param	:
	param ',' type VARIABLE
		{
   		 if(func_here($4)==1)
      			  printf("parameter already exists.\n");
   		 else
    			    assign_func($4);
		}

	| type VARIABLE
		{
		   if(func_here($2)==1)
      			 printf("parameter already exists.\n");
   		 else
      				  assign_func($2);
		}
	;





lines	: /* empty */
    |NUMBER

	| lines codes

	| declare
	;


declare	:
	type id END    	{ printf("\nValid declaration.\n"); } 
	;


type	:
	INT 

	| FLOAT

	| STRING
	;


id	:
	id ',' VARIABLE
		{
   		 if(isdeclared($3)==1)
      			  printf("\nDouble Declaration is found\n");
   		 else
    			    assign($3);
		}

	| VARIABLE
		{
		   if(isdeclared($1)==1)
      			  printf("\nDouble Declaration is found \n");
   		 else
      				  assign($1);
		}
	;


codes: 
	codes then

	|then
	;


then	:
	END

	| declare

	| expression END
		{
 		     $$=$1;
 		/*   printf("\nValue of expression: %d at line %d\n",$1,yylineno); */
		}

	| VALUE '(' VARIABLE ')' END
		{
			if(isdeclared($3)==0)
			{
				printf("Can't print, Value is not declared.\n");
			}
			else 
			{
				printf("\nValue of the variable %s:  %d\t\n",$3, store[getval($3)]);
			}
 		   
		}

	| VARIABLE '=' expression END
		{
 		    if(setval($1,$3)==0)
  		 	{
  		    	$$=0;
				printf("\nNot declared\n");
   			}
    		else
    		{
      			$$=$3;
   			}
		}
    | INC '(' VARIABLE ',' NUMBER ')' END {  int ok=0, i;
                                for( i=1; i<last_point; i++)
        {
            if(strcmp(variable[i],$3) == 0)
            {
                ok=i;
                break;
            }
        }
                                            store[ok]+=$5;
	                                         printf("inc iis done\n");}
	| DEC '(' VARIABLE ',' NUMBER ')' END {  int ok=0, i;
                                for( i=1; i<last_point; i++)
        {
            if(strcmp(variable[i],$3) == 0)
            {
                ok=i;
                break;
            }
        }
                                            store[ok]-=$5;
	                                         printf("dec iis done\n");}
	
	
    | if_blocks { conditionMatched=0;}
	| FOR '(' VARIABLE '=' NUMBER ',' VARIABLE LTEQ NUMBER ',' VARIABLE UP NUMBER')' '{' codes'}'
		{
 		    int i;
			for(i= $5 ; i<= $9 ; i+=$13)
			{
				printf("Expression in for loop increasing %d\n",i);
			} printf("\n");	 			    
		}
		
	| FOR '(' VARIABLE '=' NUMBER ',' VARIABLE GTEQ NUMBER ',' VARIABLE DOWN NUMBER ')' '{' codes'}'
		{
 		    int i;
			for(i= $5 ; i>= $9 ; i-=$13)
			{
				printf("Expression in for loop Decreasing %d\n",i);
			}printf("\n");		    
		}
	   
		    
	
	| WHILE '(' VARIABLE LT NUMBER ',' NUMBER ')' '{' codes '}'
		{
			int a = store[getval($3)], inc = $7;
			while((a+=inc)< $5)
			{
				printf("While loop is executing value of variable %s : %d\n", $3, a);
			}
		}
	

	| SWITCH '[' Exp_case ']' '{' code '}'

	;


Exp_case :
	expression
		{
    		cdefault = 0;
    		var = $1;
		}
	;


code: /* empty */

	| code CASE expression COLON '{' codes B '}'
		{
    		if($3 == var)
    			{  printf("\nswtich is found\n");
        			printf("Executed at %d\n",$3);
        			cdefault = 1;
   			 }
		}

	| code DEFAULT COLON '{' codes '}'
		{
  		  if(cdefault == 0)
   			 {
    			  cdefault = 1;
				   printf("\nswtich is found");
     			   printf("Default Block executed\n");
    			}
		}
	;
 B: BREAK END {break;printf("break is used\n");}


expression:
	NUMBER		   		  { $$ = $1;}

	| VARIABLE
		{
  		  if( isdeclared($1) == 0)
   			 {
    			    $$=0;
     			   printf("\nNot declaredd!\n");
   			 }
    		else
       			 $$=store[getval($1)];
		}
	
	| expression '+' expression	  	
		 { 	
			$$ = $1 + $3; printf("\nAddition value %d\n",$$);
		 }

	| expression '-' expression	 	  
		{
  			$$ = $1 - $3; printf("\nSubtraction value %d\n",$$);
		}

	| expression '*' expression
		{
 			   $$ = $1 * $3;
 			   printf("\nMultiplication value %d\n",$$);
		}

	| expression '/' expression	 	  
		{ 	if($3)
 			   {
  			      $$ = $1 / $3;
     				   printf("\nDivision value %d\n",$$);
  			  }
   			 else
    			{
      				 $$ = 0;
       				 printf("\nDivision by zero\t");
    			}
		}

	| expression '^' expression 		
		{ 	$$=pow($1,$3); printf("\nPower value %d\n",$$);}

	| expression '%' expression 		
		{	 $$=$1 % $3; printf("\nRemainder value %d\n",$$);}

	| '(' expression ')'		  
    		 { $$ = $2 ;}
	| expression LT expression	
		{ $$ = $1 < $3; }

	| expression GT expression	
		{ $$ = $1 > $3; }

	| expression LTEQ expression  
		{ $$ = $1 <= $3; }
	| expression NEQ expression
	{ 
		$$=(1!=$3);
	}
    | expression AND expression
	{
		$$=($1 && $3);
	}
	|expression OR expression
	{
		$$=( $1 ||$3);
	}
	| expression GTEQ expression   
 		 { $$ = $1 >= $3; }
	|FACT expression           {int ans = 1; for(int i=1; i<=$2; i++){ans*=i;}printf("Factorial of %d is %d\n",$2,ans);}
    |LEAPYEAR expression     {int year=$2; if((year%4==0 &&year%100!=0)||(year%400==0))printf("%d is a leap year\n" ,year);else printf("%d is not a leap year\n" ,year);   }
	|SQRT expression       { printf("Value of root=%lf\n",sqrt($2*1.0));}
	
	|GCD '(' expression ',' expression ')'   { int n1=$3,n2=$5,g;
	                                            for(int i=1;i<=n1&&i<=n2;i++)
												{
												  if(n1%i==0&&n2%i==0)
												  {
												     g=i;
												
												 }
												 }
											printf("Gcd of %d and %d = %d\n",$3,$5,g);
										}
	|LCM '(' expression ',' expression ')'  { int n1=$3,n2=$5,g;
	                                            for(int i=1;i<=n1&&i<=n2;i++)
												{
												  if(n1%i==0&&n2%i==0)
												  {
												     g=i;
												
												 }
												 }
												 int x=n1/g*n2;
											printf("Lcm of %d and %d = %d\n",$3,$5,x);
										}
	|MAX '(' expression ',' expression ')'  { int n1=$3,n2=$5;
	                                            if(n1>n2)
											printf("Max of %d and %d = %d\n",$3,$5,n1);
											else
											printf("Max of %d and %d = %d\n",$3,$5,n2);

										}
    |MIN '(' expression ',' expression ')'  { int n1=$3,n2=$5;
	                                            if(n1>n2)
											printf("Min of %d and %d = %d\n",$3,$5,n2);
											else
											printf("Min of %d and %d = %d\n",$3,$5,n1);

										}
	| EXCNG '(' expression ',' expression ')' { int n1=$3,n2=$5,temp; temp=$3;$3=$5;$5=temp; 
	                                          printf("After swapping the values are %d %d\n",$3,$5); }
										;

	if_blocks:
	   IF if_block else_statement {}	
	   ;

	if_block:
	   '[' expression ']' '{' codes '}'		{
    int isTrue = (fabs($2)>1e-9);
                    if(isTrue){
                       
                        printf("Condition in if block is true.\n");
                       
                   
                        conditionMatched = 1;
                    }
                    else{
                        
                        printf("Condition in if block is false.\n");
                    
                    }
		
	   }					
	
										
   ;


   else_statement:
            | elif_statement
            | elif_statement   single_else
            | single_else
    ;	
single_else: ELSE '{' codes  '}' 
                {
                    if(conditionMatched){
                    
                        printf("Condition already fulfilled.Ignoring else block.\n");
                 
                    }
                    else{
                        double isTrue =1;
                        if(isTrue){
                       
                            printf("Condition in else block is true.\n");
                        
                    
                            conditionMatched = 1;
                        }
                        else{
                         
                            printf("Condition in else block is false.\n");
                         
                        }
                    }  
                }
    ;
elif_statement:
            elif_statement  single_elif
            | single_elif 
    ;
single_elif:
            ELIF '[' expression ']' '{' codes '}'	 
                {
                    if(conditionMatched){
                      //  SetColor(8);
                        printf("Condition already fulfilled.Ignoring elif block.\n");
                       // SetColor(2);
                    }
                    else{
                            int isTrue = (fabs($3)>1e-9);
                            if(isTrue){
                            //    SetColor(8);
                                printf("Condition in elif block is true.\n");
                            //    SetColor(2);
                          //      printf("Value of expression in elif block is %.4lf\n",$6);
                                conditionMatched = 1;
                            }
                            else{
                             //   SetColor(8);
                                printf("Condition in elif block is false.\n");
                              ///  SetColor(2);
                            }
                        }
                }
    ;






%%



int yyerror(char *s)
{
    printf( "%s\n", s);
	
}








