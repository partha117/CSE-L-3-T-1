%x Single_Comment_State
%x Multi_Comment_State
%x String_State
%x Again
%{
#include<iostream>

#include<string>
#include"1305117_SymbolTable.h"
#include "y.tab.h"


using namespace std;

extern YYSTYPE yylval;
SymbolTable *st=new SymbolTable(10);

void yyerror(char *);


int word_count=0;
int line_count=1;
int error_count=0;

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
mi{minus}{minus}
Inc ({pl})
Dec {mi}
Id {Letter}({Letter}|{Digit})*
End "*/"
character (\'\\n\')|(\'\\t\')|(\'\\\\')|(\'\"\')|(\'\\a\')|(\'\\f\')|(\'\\r\')|(\'\\b\')|(\'\\v\')|(\'\\0\')
other [\n]
Start [/][*]
%%      
if                {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"IF> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        return IF;
                   
                  }
for               {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"FOR> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        return FOR;
                   
                  }
do                {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"DO> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        return DO;
                    
                  }
int               {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"INT> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        return INT;
                     
                  }
float             {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"FLOAT> "<<"Lexeme : "<<yytext<<" found"<<endl;
                        return FLOAT;
                     
                  }
void              {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"VOID> "<<"Lexeme : "<<yytext<<" found"<<endl;
                        return VOID; 
                     
                  }
switch            {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"SWITCH> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        return SWITCH;
                    
                  }
default           {
                   
                        //logout<<"Line no "<<line_count<<" Token : <"<<"DEFAULT> "<<"Lexeme : "<<yytext<<" found"<<endl;
                        return DEFAULT;
                    
                  }
else              {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"ELSE> "<<"Lexeme : "<<yytext<<" found"<<endl;
                        return ELSE; 
                         
                  }
while             {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"WHILE> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        return WHILE;
                    
                  }
break             {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"BREAK>"<<"Lexeme : "<<yytext<<" found"<<endl; 
                        return BREAK;
                     
                  }
char              {
                   
                        //logout<<"Line no "<<line_count<<" Token : <"<<"CHAR> "<<"Lexeme : "<<yytext<<" found"<<endl;
                        return CHAR; 
                    
                  }

return            {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"RETURN> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                        return RETURN;
                    
                  }
case              {
                   
                        //logout<<"Line no "<<line_count<<" Token : <"<<"CASE> "<<"Lexeme : "<<yytext<<" found"<<endl;
                        return CASE;
                     
                  }
continue          {
                    
                        //logout<<"Line no "<<line_count<<" Token : <"<<"CONTINUE> "<<"Lexeme : "<<yytext<<" found"<<endl;
                        return CONTINUE;
                   
                  }


main              {
                        return MAIN;
                  }
println           {
                        return PRINTLN;
                  }
{Digit}+          {
                   //SymbolInfo *symbolinfo=st->getSymbol((st->insert("CONST_INT",yytext)));
                   yylval.ival=atoi(yytext);
                   return CONST_INT;

                  }
{Number}          {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("CONST_FLOAT",yytext)));
                    yylval.fval=atof(yytext);
                    return CONST_FLOAT;
                  }
\'.\'|{character} {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("CONST_CHAR",yytext)));
                    yylval.cval=yytext;
                    return CONST_CHAR;
                  }
{Inc}             {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("INCOP",yytext)));
                    //yylval.si=symbolinfo;  
                    return INCOP;                 
                  }
{Dec}             {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("INCOP",yytext)));
                    //yylval.si=symbolinfo;  
                    return DECOP;                 
                  }
[+-]              {
                    SymbolInfo *symbolinfo=new SymbolInfo("ADDOP",(char*)yytext);
                    yylval.si=symbolinfo;
                    ////printf(" from l file %s ",symbolinfo->getName());
                    return ADDOP;
                  }
[*/%]             {

                    SymbolInfo *symbolinfo=new SymbolInfo("MULOP",(char*)yytext);
                    yylval.si=symbolinfo;
                    ////printf(" from l file %s ",symbolinfo->getName());
                    
                    
                    
                    return MULOP;
                  }
(<|<=|>|>=|==|!=) {
                    SymbolInfo *symbolinfo=new SymbolInfo("MULOP",(char*)yytext);
                    yylval.si=symbolinfo;
                    
                    return RELOP;
                  }
[=]               {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("ASSIGNOP",yytext)));
                    //yylval.si=symbolinfo;
                    return ASSIGNOP;
                   
                  }
(&&|\|\||!)       {
                    SymbolInfo *symbolinfo=new SymbolInfo("MULOP",(char*)yytext);
                    yylval.si=symbolinfo;
                    
                    return LOGICOP;
                   
                  }
(\()             {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("LPAREN",yytext)));
                    //yylval.si=symbolinfo;
                    return LPAREN;
                   
                 }
(\))             {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("RPAREN",yytext)));
                    //yylval.si=symbolinfo;
                    return RPAREN;

                 }
(\{)             {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("LCURL",yytext)));
                    //yylval.si=symbolinfo;
                    return LCURL;

                 }
(\})             {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("RCURL",yytext)));
                    //yylval.si=symbolinfo;
                    return RCURL;
                 }
(\[)             {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("LTHIRD",yytext)));
                    //yylval.si=symbolinfo;
                    return LTHIRD;
                 }
(\])             { 
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("RTHIRD",yytext)));
                    //yylval.si=symbolinfo; 
                    return RTHIRD;
                 }
\,               {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("COMMA",yytext)));
                    //yylval.si=symbolinfo;
                    return COMMA;

                 } 
\;               {
                    //SymbolInfo *symbolinfo=st->getSymbol((st->insert("SEMICOLON",yytext)));
                    //yylval.si=symbolinfo;
                    return SEMICOLON;
                 }
{Id}             {
                    ////printf("%s from here\n",yytext);
                    SymbolInfo *symbolinfo=new SymbolInfo("ID",(char*)yytext);
                    ////printf("from l file found  %s\n",symbolinfo->getName());
                    yylval.si=symbolinfo;
                    ////printf("from l\n");
                    return ID;
                 }
\/\/              {BEGIN Single_Comment_State;}
<Single_Comment_State>.*                                 {BEGIN INITIAL;
                                                          
                                                          //logout<<"Line no "<<line_count<<" Token : <"<<"COMMENT> "<<"Lexeme : "<<yytext<<" found"<<endl; 
                                                         }
{Start}                                                  {BEGIN Multi_Comment_State;
                                                          
                                                          //logout<<"Line no "<<line_count<<" Token : <"<<"COMMENT> Lexeme :"; 
                                                         }
<Multi_Comment_State><<EOF>>                             {
                                                          error_count++;
                                                          //logout<<"Line no "<<line_count<<" Error : Unterminated comment error"<<endl;
                                                          //print_message();
                                                          return 0;
                                                         }
<Multi_Comment_State>([ -~]{-}[\n\*\/])*                 {
                                                            //logout<<yytext;
                                                         }
<Multi_Comment_State>[\n]                                {line_count++;
                                                           
                                                           //logout<<yytext;
                                                         }
<Multi_Comment_State>{End}                               {BEGIN INITIAL;
                                                          
                                                          //logout<<"found"<<endl;
                                                         }
\"                                                       {BEGIN String_State;
                                                          //logout<<"Token <String> Lexeme \"";         
                                                         }
<String_State>([a-zA-Z0-9 ,\.;\'\[\]\-\=\+\*\>/</:/|/{/}])* {}   
<String_State>(\\t)                                        {}
<String_State>(\\\\)                                        {}

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
                                                          //logout<<" Line no "<<line_count<<" Error : Unterminated string error"<<endl;
                                                          BEGIN INITIAL;
                                                        }

<String_State>[\"]                                       {BEGIN INITIAL;
                                                          //logout<<"\" found"<<endl;
                                                         }
                                                         
[\n]                                                     {line_count++;}
({Digit}*\.+{Digit}+\.)({Digit}|\.)*                     {
                                                          error_count++;
                                                          //logout<<"Line no "<<line_count<<" Error : Too many decimal point"<<endl;
                                                          return TOO_MANY_DECIMAL_POINT;
                                                         }
({Digit}+(\.{Digit}+)?(E[+-]?)+{Digit}+\.+(E[+-]?|{Digit}|\.)*)  {
                                                           error_count++;
                                                           //logout<<"Line no "<<line_count<<" Error : Ill formed number"<<endl;
                                                           return ILL_FORMED_NUMBER;
                                                         }
({Digit}+{Letter}+)                                      {
                                                           error_count++;
                                                           //logout<<"Line no "<<line_count<<" Error : Invalid prefix"<<endl;
                                                         }
\'([a-zA-Z0-9 ])*                                        {
                                                           error_count++;
                                                           //logout<<"Line no "<<line_count<<" Error : Unterminated Character"<<endl; 
                                                         }
(\'..+\')                                                {
                                                           error_count++;
                                                           //logout<<"Line no "<<line_count<<" Error : Multi charecter constant"<<endl;
                                                         }

<<EOF>>                                                  {
                                                          //print_message();
                                                          return 0;
                                                         }
[.]                                                      {//logout<<"Line no "<<line_count<<" Error : Unrecognized character"<<endl;
                                                         }

%%
int yywrap(void)
{
  
  return 1;
}

