%option noyywrap
%x Single_Comment_State
%x Multi_Comment_State
%x String_State
%x Again
%{
#include<stdio.h>
#include<stdlib.h>
#include"1305117_SymbolTable.h"

int word_count=0;
int line_count=1;
int error_count=0;
SymbolTable st(10);
ofstream logout;
ofstream tokenout;
void IncWc(){
	word_count++;
}
void print_message(){
          logout<<"Total lines : "<<line_count-1<<endl<<"Total errors : "<<error_count<<endl;
          st.print(tokenout);
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
character (\'\\n\')|(\'\\t\')|(\'\\\\')|(\'\"\')|(\'\\a\')|(\'\\f\')|(\'\\r\')|(\'\\b\')|(\'\\v\')|(\'\\0\')
other [\n]
Start [/][*]
%%      
if                {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"IF> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                   
                  }
for               {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"FOR> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                   
                  }
do                {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"DO> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                    
                  }
int               {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"INT> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                     
                  }
float             {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"FLOAT> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                     
                  }
void              {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"VOID> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                     
                  }
switch            {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"SWITCH> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                    
                  }
default           {
                   
                        logout<<"Line no "<<line_count<<" Token : <"<<"DEFAULT> "<<"Lexeme : "<<yytext<<" found"<<endl;
                    
                  }
else              {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"ELSE> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                         
                  }
while             {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"WHILE> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                    
                  }
break             {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"BREAK>"<<"Lexeme : "<<yytext<<" found"<<endl; 
                     
                  }
char              {
                   
                        logout<<"Line no "<<line_count<<" Token : <"<<"CHAR> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                    
                  }
double            {
                   
                        logout<<"Line no "<<line_count<<" Token : <"<<"DOUBLE> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                    
                  }
return            {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"RETURN> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                    
                  }
case              {
                   
                        logout<<"Line no "<<line_count<<" Token : <"<<"CASE> "<<"Lexeme : "<<yytext<<" found"<<endl;
                     
                  }
continue          {
                    
                        logout<<"Line no "<<line_count<<" Token : <"<<"CONTINUE> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                   
                  }
{Digit}+          {
                   if((st.insert("CONST_INT",yytext)).getI()==-1)
	            {
                         logout<<"Token <CONST_INT> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"CONST_INT> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }

                  }
{Number}          {
                  
                   if((st.insert("CONST_FLOAT",yytext)).getI()==-1)
	            {
                        logout<<"Token <CONST_FLOAT> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"CONST_FLOAT> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);                   }
                  }
\'.\'|{character}   {
                   
                   if((st.insert("CONST_CHAR",yytext)).getI()==-1)
	            {
                        logout<<"Token <CONST_CHAR> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"CONST_CHAR> "<<"Lexeme : "<<yytext<<" found"<<endl;
                        st.print_not_empty(logout); 
                   }
                  }
{Inc}             {
                   
                   if((st.insert("INCOP",yytext)).getI()==-1)
	            {
                        logout<<"Token <INCOP> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"INCOP> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
[+-]              {
                   
                   if((st.insert("ADDOP",yytext)).getI()==-1)
	            {
                        logout<<"Token <ADDOP> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"ADDOP> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
[*/%]             {
                   
                   if((st.insert("MULOP",yytext)).getI()==-1)
	            {
                        logout<<"Token <MULOP> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"MULOP> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
(<|<=|>|>=|==|!=) {
                   if((st.insert("RELOP",yytext)).getI()==-1)
	            {
                        logout<<"Token <RELOP> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"RELOP> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
[=]               {
                   if((st.insert("ASSIGNOP",yytext)).getI()==-1)
	            {
                        logout<<"Token <ASSIGNOP> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"ASSIGNOP> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
(&&|\|\||!)       {
                   if((st.insert("LOGICOP",yytext)).getI()==-1)
	            {
                        logout<<"Token <LOGICOP> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"LOGICOP> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
(\()           {
                   if((st.insert("LPAREN",yytext)).getI()==-1)
	            {
                        logout<<"Token <LPAREN> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"LPAREN> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                }
(\))             {
                   if((st.insert("RPAREN",yytext)).getI()==-1)
	            {
                        logout<<"Token <RPAREN> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"RPAREN> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
(\{)         {
                   
                   if((st.insert("LCURL",yytext)).getI()==-1)
	            {
                        logout<<"Token <LCURL> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"LCURL> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
(\})         {
                   
                   if((st.insert("RCURL",yytext)).getI()==-1)
	            {
                        logout<<"Token <RCURL> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"RCURL> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
(\[)          {
                   if((st.insert("LBRACKET",yytext)).getI()==-1)
	            {
                        logout<<"Token <LBRACKET> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"LBRACKET> "<<"Lexeme : "<<yytext<<" found"<<endl;
                        st.print_not_empty(logout); 
                   }
                  }
(\])          {
                   if((st.insert("RBRACKET",yytext)).getI()==-1)
	            {
                        logout<<"Token <RBRACKET> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"RBRACKET> "<<"Lexeme : "<<yytext<<" found"<<endl;
                        st.print_not_empty(logout); 
                   }
                  }
\,                {
                   if((st.insert("COMMA",yytext)).getI()==-1)
	            {
                        logout<<"Token <COMMA> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"COMMA> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  } 
\;                {
                   if((st.insert("SEMICOLON",yytext)).getI()==-1)
	            {
                        logout<<"Token <SEMICOLON> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"SEMICOLON> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
{Id}              {
                   if((st.insert("ID",yytext)).getI()==-1)
	            {
                        logout<<"Token <ID> Lexeme : "<<yytext<<" found in line "<<line_count<<" already exist in Symobol Table"<<endl;
         	    }
                   else
                   {
                        logout<<"Line no "<<line_count<<" Token : <"<<"ID> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        st.print_not_empty(logout);
                   }
                  }
\/\/              {BEGIN Single_Comment_State;}
<Single_Comment_State>.*                                 {BEGIN INITIAL;
                                                          
                                                          logout<<"Line no "<<line_count<<" Token : <"<<"COMMENT> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                                                         }
{Start}                                                  {BEGIN Multi_Comment_State;
                                                          
                                                          logout<<"Line no "<<line_count<<" Token : <"<<"COMMENT> Lexeme :"; 
                                                         }
<Multi_Comment_State><<EOF>>                             {
                                                          error_count++;
                                                          logout<<"Line no "<<line_count<<" Error : Unterminated comment error"<<endl;
                                                          print_message();
                                                          return 0;
                                                         }
<Multi_Comment_State>([ -~]{-}[\n\*\/])*                 {
                                                            logout<<yytext;
                                                         }
<Multi_Comment_State>[\n]                                {line_count++;
                                                           
                                                           logout<<yytext;
                                                         }
<Multi_Comment_State>{End}                               {BEGIN INITIAL;
                                                          
                                                          logout<<"found"<<endl;
                                                         }
\"                                                       {BEGIN String_State;
                                                          logout<<"Token <String> Lexeme \"";         
                                                         }
<String_State>([a-zA-Z0-9 ,\.;\'\[\]\-\=\+\*\>/</:/|/{/}])* {logout<<yytext;}   
<String_State>(\\t)                                        {logout<<yytext;}
<String_State>(\\\\)                                        {logout<<"\\";}

<String_State>\\                                        {
                                                          BEGIN Again;
                                                         
                                                        }
<Again>\n                                               {

                                                          
                                                          line_count++;
                                                          
                                                          BEGIN String_State;
                                                        }
<String_State>\n                                        {
                                                          line_count++;
                                                          error_count++;
                                                          logout<<" Line no "<<line_count<<" Error : Unterminated string error"<<endl;
                                                          BEGIN INITIAL;
                                                        }

<String_State>[\"]                                       {BEGIN INITIAL;
                                                          logout<<"\" found"<<endl;
                                                         }
                                                         
[\n]                                                     {line_count++;}
({Digit}*\.+{Digit}+\.)({Digit}|\.)*                        {
                                                          error_count++;
                                                          logout<<"Line no "<<line_count<<" Error : Too many decimal point"<<endl;
                                                         }
({Digit}+(\.{Digit}+)?(E[+-]?)+{Digit}+\.+(E[+-]?|{Digit}|\.)*)  {
                                                           error_count++;
                                                           logout<<"Line no "<<line_count<<" Error : Ill formed number"<<endl;
                                                         }
({Digit}+{Letter}+)                                      {
                                                           error_count++;
                                                           logout<<"Line no "<<line_count<<" Error : Invalid prefix"<<endl;
                                                         }
\'([a-zA-Z0-9 ])*                                              {
                                                           error_count++;
                                                           logout<<"Line no "<<line_count<<" Error : Unterminated Character"<<endl; 
                                                         }
(\'..+\')                                                {
                                                           error_count++;
                                                           logout<<"Line no "<<line_count<<" Error : Multi charecter constant"<<endl;
                                                         }

<<EOF>>                                                  {
                                                          print_message();
                                                          return 0;
                                                         }
[.]                                                      {logout<<"Line no "<<line_count<<" Error : Unrecognized character"<<endl;}

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
	
        logout.open("1305117_log.txt");
	tokenout.open("1305117_token.txt");
	yyin= fin;
	yylex();
	fclose(yyin);
	tokenout.close();
        logout.close();
	return 0;
}
