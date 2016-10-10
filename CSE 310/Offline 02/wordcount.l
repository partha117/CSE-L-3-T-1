%option noyywrap
%x Single_Comment_State
%x Multi_Comment_State
%{
#include<stdio.h>
#include<stdlib.h>
#include"SymbolTable.h"

int word_count=0;
int line_count=0;
int error_count=0;
int comment_line=0;
SymbolTable st(10);
void IncWc(){
	word_count++;
}
%}
Letter [a-zA-Z]
Digit[0-9]
Number{Digit}+(\.{Digit}+)?(E[+-]?{Digit}+)?
plus [+]
minus[-]
pl{plus}{plus}
mi{minus}
Inc ({pl}|{mi})
Id {Letter}({Letter}|{Digit})*
End "*/"
Start [/][*]
%%
if                {printf("<IF>\n");}
for               {printf("<FOR>\n");}
do                {printf("<DO>\n");}
int               {printf("<INT>\n");}
float             {printf("<FLOAT>\n");}
void              {printf("<VOID>\n");}
switch            {printf("<SWITCH>\n");}
default           {printf("<DEFAULT>\n");}
else              {printf("<ELSE>\n");}
while             {printf("<WHILE>\n");}
break             {printf("<BREAK>\n");}
char              {printf("<CHAR>\n");}
double            {printf("<DOUBLE>\n");}
return            {printf("<RETURN>\n");}
case              {printf("<CASE>\n");}
continue          {printf("<CONTINUE>\n");}
{Digit}+          {printf("<CONST_INT,%s>\n",yytext);
                   SymbolInfo*si=new SymbolInfo("CONST_INT",yytext);
                   st.insert(si);
                  }
{Number}          {printf("<CONST_FLOAT,%s>\n",yytext);
                   SymbolInfo*si=new SymbolInfo("RELOP",yytext);
                   st.insert(si);
                  }
\'.\'             {printf("<CONST_CHAR,%s>\n",yytext);
                   SymbolInfo*si=new SymbolInfo("CONST_CHAR",yytext);
                   st.insert(si);
                  }
{Inc}             {printf("<INCOP,%s>\n",yytext);
                   SymbolInfo*si=new SymbolInfo("RELOP",yytext);
                   st.insert(si);
                  }
[+-]              {printf("<ADDOP,%s>\n",yytext);
                   SymbolInfo*si=new SymbolInfo("RELOP",yytext);
                   st.insert(si);
                  }
[*/%]             {printf("<MULOP,%s>\n",yytext);
                   SymbolInfo*si=new SymbolInfo("RELOP",yytext);
                   st.insert(si);
                  }
(<|<=|>|>=|==|!=) {printf("<RELOP,%s>\n",yytext);
                   SymbolInfo*si=new SymbolInfo("RELOP",yytext);
                   st.insert(si);
                  }
[=]               {printf("<ASSIGNOP,%s>\n",yytext);
                   SymbolInfo*si=new SymbolInfo("RELOP",yytext);
                   st.insert(si);
                  }
(&&|\|\||!)       {printf("<LOGICOP,%s>\n",yytext);
                   SymbolInfo*si=new SymbolInfo("RELOP",yytext);
                   st.insert(si);
                  }
(\(|\))           {printf("<PAREN,%s>\n",yytext);
                   SymbolInfo*si=new SymbolInfo("RELOP",yytext);
                   st.insert(si);
                  }
(\{|\})           {printf("<CURL,%s>\n",yytext);
SymbolInfo*si=new SymbolInfo("RELOP",yytext);
                   st.insert(si);}
(\[|\])           {printf("<BRACKET,%s>\n",yytext);}
\,                {printf("<COMMA,%s>\n",yytext);} 
\;                {printf("<SEMICOLON,%s>\n",yytext);}
{Id}              {printf("<ID,%s>\n",yytext);}
\/\/              {BEGIN Single_Comment_State;}
<Single_Comment_State>.*                                 {BEGIN INITIAL;
                                                          printf("Single Comment %s\n",yytext);
                                                         }
{Start}                                                  {BEGIN Multi_Comment_State;
                                                          printf("Start\n");
                                                         }
<Multi_Comment_State><<EOF>>                             {printf("Error Comment not Ended in line %d\n",line_count);
                                                          return 0;
                                                         }
<Multi_Comment_State>[a-zA-z0-9]                         {printf("%s",yytext);}
<Multi_Comment_State>[\n]                                {line_count++;
                                                           printf("%s",yytext);
                                                         }
<Multi_Comment_State>{End}                               {BEGIN INITIAL;
                                                          printf("Got end\n");
                                                         }
\"([^\"])*\"	                                         {printf("<STRING,%s>\n",yytext);}
[\n]                                                     {line_count++;}
({Digit}+\.{Digit}+\.).*                                 {printf("Too many decimal point Error in line %d\n",line_count+1);}
({Digit}+(\.{Digit}+)?(E[+-]{Digit}*\..*))               {printf("Ill formed number in line%d\n",line_count+1);}
({Digit}+{Letter}+)                                      {printf("Invalid prefix in line %d\n",line_count+1);}
('..+')                                                  {printf("Multi charecter constant error in line %d\n",line_count+1);}
\"([^\"])*                                               {printf("Unfinished string error in line %d\n",line_count+1);}
^.                                                       {printf("Unrecognized charecter error in line %d\n",line_count+1);}
<<EOF>>                                                  {printf("Total Line Number: %d and word number: %d\n",line_count,word_count);
st.print();
                                                          return 0;
                                                         }
%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	

	yyin= fin;
	yylex();
	fclose(yyin);
	return 0;
}
