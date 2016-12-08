
%{
#include <iostream>

#include<string>
#include"1305117_SymbolTable.h"
//#define YYSTYPE SymbolInfo      /* yyparse() stack type */
extern FILE* yyin;
int yydebug;
extern SymbolTable *st;
extern int line_count;
ofstream tokenout;
double globaltemp=0;
int Global=1;
int nowType=1;
char * globalType;
int errorCounter=0;
void yyerror(const char *s){
	//printf("%s\n",s);
  tokenout<<"\n"<<"Eror: "<<s<<"  at line "<<line_count<<endl;
}

int yylex(void);


%}

%token NEWLINE NUMBER PLUS MINUS SLASH ASTERISK ASSIGNOP NOT SEMICOLON COMMA LCURL RCURL LTHIRD RTHIRD INCOP DECOP IF ELSE FOR WHILE CHAR RETURN VOID MAIN PRINTLN DO SWITCH DEFAULT BREAK CASE CONTINUE

%union{ SymbolInfo * si;float fval;int ival;char *cval; store *sr;}

%token <fval> FLOAT;
%token <ival> INT; 
%type <si> factor simple_expression term unary_expression rel_expression logic_expression expression expression_statement SEMICOLON ;
%token <ival>CONST_INT;
%token <fval>CONST_FLOAT;
%token <cval>CONST_CHAR;
%token <si>LOGICOP MULOP RELOP ADDOP LPAREN RPAREN ;
%token <si> ID TOO_MANY_DECIMAL_POINT ILL_FORMED_NUMBER ;
%type <si> variable;

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%error-verbose

%%
withGlobal:var_declaration Others{;tokenout<<"\n"<<"withGlobal:var_declaration Others"<<endl;}
          |function_declaration Others{tokenout<<"\n"<<"withGlobal:Others"<<endl;}
          |var_declaration function_declaration Others{{tokenout<<"\n"<<"Others:var_declaration function_declaration Others "<<endl;} }
          |Others {tokenout<<"\n"<<"withGlobal:Others"<<endl;}
          ;
Others:  function_definition Program {Global=0;tokenout<<"\n"<<"Others:  function_definition Program "<<endl;}      
        | Program {Global=0;tokenout<<"\n"<<"Others:Program "<<endl;} 

       ;
function_definition:type_specifier ID LPAREN function_selection RPAREN compound_statement{nowType++;tokenout<<"\n"<<"function_definition:type_specifier ID LPAREN function_selection RPAREN compound_statement"<<endl;}
                  | function_definition type_specifier ID LPAREN function_selection RPAREN compound_statement{nowType++;tokenout<<"\n"<<"function_definition type_specifier ID LPAREN function_selection RPAREN compound_statement"<<endl;}
                  ;

function_selection:
                  | type_specifier ID{tokenout<<"\n"<<"function_selection:type_specifier ID"<<endl;}
                  |function_selection COMMA type_specifier ID{tokenout<<"\n"<<"function_selection:function_selection COMMA type_specifier ID"<<endl;}

                  ;

function_declaration : type_specifier ID LPAREN selection RPAREN SEMICOLON {//printf("Now in var_dec \n");
                                                              tokenout<<"\n"<<"function_declaration : type_specifier ID LPAREN selection RPAREN SEMICOLON"<<endl;
                                                            }
    |  function_declaration type_specifier ID LPAREN selection RPAREN SEMICOLON{tokenout<<"\n"<<"function_declaration:function_declaration type_specifier ID LPAREN selection RPAREN SEMICOLON"<<endl;}
    ;
selection:type_specifier {tokenout<<"\n"<<"selection:type_specifier"<<endl;}
          |selection COMMA type_specifier {tokenout<<"\n"<<"selection:selection COMMA type_specifier"<<endl;}
          |VOID {tokenout<<"\n"<<"selection:VOID"<<endl;}
          ;
Program : INT MAIN LPAREN RPAREN compound_statement{tokenout<<"\n"<<"Program : Int main lparen rparen compound_statement"<<endl;}
         ;



compound_statement : LCURL var_declaration statements RCURL {//printf("Now in comp_state \n");
                                                              tokenout<<"\n"<<"compound_statement: Lcurl var declaration statements RCURL"<<endl;
                                                            }
       | LCURL statements RCURL{//printf("compound_statement\n");
                                  tokenout<<"\n"<<"compound_statements:Lcurl statements RCURL"<<endl;
                               }
       | LCURL RCURL{tokenout<<"\n"<<"compound_statements:Lcurl RCURL"<<endl;}
       ;

       
var_declaration : type_specifier declaration_list SEMICOLON {//printf("Now in var_dec \n");
                                                              tokenout<<"\n"<<"var_declaration: type_specifier declaration_list SEMICOLON"<<endl;
                                                            }
    |  var_declaration type_specifier declaration_list SEMICOLON{tokenout<<"\n"<<"var_declaration:var_declaration type_specifier declaration_list SEMICOLON"<<endl;}
    ;

type_specifier  : INT {
                        if(Global==1)
                        {
                         globalType="int";
                         tokenout<<"\n"<<"type_specifier:INT"<<endl;
                        }
                        else
                        {
                          globalType="int";
                          tokenout<<"\n"<<"type_specifier:INT"<<endl;
                        }
                      }
    | FLOAT           {
                        if(Global==1)
                        {
                         globalType="float";
                         tokenout<<"\n"<<"type_specifier:IFLOAT"<<endl;
                        }
                        else
                        {
                          globalType="float";
                          tokenout<<"\n"<<"type_specifier:FLOAT"<<endl;
                        }
                      }
    | CHAR            {
                        if(Global==1)
                        {
                         globalType="char";
                         tokenout<<"\n"<<"type_specifier:CHAR"<<endl;
                        }
                        else
                        {
                          globalType="char";
                          tokenout<<"\n"<<"type_specifier:CHAR"<<endl;
                        }
                      }
    ;
      
declaration_list : declaration_list COMMA ID {
                                              //printf("here1");
                                               
                                               position pos=st->lookUp($3->getName());
                                               tokenout<<"\n"<<"NOWTYPE "<<nowType<<endl;
                                                if((pos.getI()==-1)||((pos.getI()!=-1)&&((st->getSymbol(pos))->getvarScope())!=nowType))
                                                {
                                                 $3->setType(globalType);
                                                 $3->setvarScope(nowType);
                                                 st->insert($3);
                                                }
                                                else
                                                {
                                                     tokenout<<"\n"<<"Error:    Duplicate declaration of "<<$3->getName()<<" at line "<<line_count<<endl;
                                                       errorCounter++;
                                                }
                                                tokenout<<"\n"<<"declaration_list:declaration_list COMMA ID"<<endl<<$3->getName()<<"\n\n";
                                              }
     | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD { 
                                                          //printf("\n it is global type %s  %s %d here\n",globalType,$3->getName(),$5);

                                                            

                                                            position pos=st->lookUp($3->getName());
                                                            if((pos.getI()==-1)||((pos.getI()!=-1)&&((st->getSymbol(pos))->getvarScope())!=nowType))
                                                            {
                                                                  SymbolInfo *temp=new SymbolInfo(globalType,$3->getName(),$5);
                                                                  st->insert(temp);
                                                                  temp->setvarScope(nowType);
                                                                  delete $3;
                                                            }
                                                            else
                                                            {
                                                                      tokenout<<"\n"<<"Error:    Duplicate declaration of "<<$3->getName()<<" at line "<<line_count<<endl;
                                                                      errorCounter++;
                                                            }
                                                            tokenout<<"\n"<<"declaration_list:declaration_list COMMA ID LTHIRD CONST_INT RTHIRD"<<endl<<$3->getName()<<"\n\n";

                                                          }
     | ID { //printf("heree2");
            position pos=st->lookUp($1->getName());
            tokenout<<"\n"<<"NOWTYPE "<<nowType<<endl;
            if((pos.getI()==-1)||((pos.getI()!=-1)&&((st->getSymbol(pos))->getvarScope())!=nowType))
            {
              $1->setType(globalType);
              st->insert($1);
              $1->setvarScope(nowType);
            }
            else
            {
              tokenout<<"\n"<<"Error:    Duplicate declaration of "<<$1->getName()<<" at line "<<line_count<<endl;
              errorCounter++;
            }
            tokenout<<"\n"<<"declaration_list:ID"<<endl<<$1->getName()<<"\n\n";
          }
     | ID LTHIRD CONST_INT RTHIRD {
                                   //printf("here last");
                                  
                                   position pos=st->lookUp($1->getName());
                                   //printf("%d\n",pos.getI());
                                  if((pos.getI()==-1)||((pos.getI()!=-1)&&((st->getSymbol(pos))->getvarScope())!=nowType))
                                  {
                                    //printf("here last");
                                     SymbolInfo *temp=new SymbolInfo(globalType,$1->getName(),$3);
                                     st->insert(temp);
                                     temp->setvarScope(nowType);
                                     delete $1;
                                      //printf("%d length\n",temp->getLength());
                                  }
                                    else
                                    {
                                            //printf("Now \n");
                                           tokenout<<"\n"<<"Error:    Duplicate declaration of "<<$1->getName()<<"at line "<<line_count<<endl;
                                          errorCounter++;
                                    }
                                    tokenout<<"\n"<<"declaration_list:ID LTHIRD CONST_INT RTHIRD"<<endl<<$1->getName()<<"\n\n";

                                  }
     ;

statements : statement {//printf("Now in Statemnts statement  first\n");
                          tokenout<<"\n"<<"statements:statement"<<endl;
                        }
     | statements statement {//printf("Now in Statemnts statements  first\n");
                              tokenout<<"\n"<<"statements:statements statement"<<endl;
                            }
     ;


statement  : expression_statement {//printf("Now in statement expstate first\n");
                                      tokenout<<"\n"<<"statement:exprssion_statement"<<endl;
                                  }
     | compound_statement {tokenout<<"\n"<<"statement:compound_statement"<<endl;}
     | FOR LPAREN expression_statement expression_statement expression RPAREN statement {tokenout<<"\n"<<"statement:for lparen exprssion_statement exprssion_statement expression RPAREN"<<endl;delete $3;}
     | IF LPAREN expression RPAREN statement   {tokenout<<"\n"<<"statement:IF LPAREN expression RPAREN statement"<<endl;delete $3;} %prec LOWER_THAN_ELSE;
     | IF LPAREN expression RPAREN statement ELSE statement{tokenout<<"\n"<<"statement:IF LPAREN expression RPAREN statement else statement"<<endl;delete $3;}
     | WHILE LPAREN expression RPAREN statement {tokenout<<"\n"<<"statement:WHILE LPAREN expression RPAREN statement"<<endl; delete $3;}
     | PRINTLN LPAREN ID RPAREN SEMICOLON {
                                             position pos=st->lookUp($3->getName());
                                             if((pos.getI()==-1)||((pos.getI()!=-1)&&((st->getSymbol(pos))->getvarScope())!=nowType))
                                             {
                                              tokenout<<"\n"<<"Error:    Trying to print undeclared id "<<$3->getName()<<"at line "<<line_count<<endl;
                                              errorCounter++;
                                             }
                                            else
                                            {
                                             SymbolInfo *temp1=st->getSymbol(pos);
                                              if(strcmp(temp1->getType(),"int")==0)
                                              {
                                                printf("\n ID %s  value %d\n",temp1->getName(),(int)temp1->getValue());
                                              }
                                            else if(strcmp($3->getType(),"float")==0)
                                            {
                                              printf("\n ID %s  value %f\n",temp1->getName(),temp1->getValue());
                                            }
                                            else if((strcmp($3->getType(),"char"))==0)
                                            {
                                              printf("\n ID %s  value %s\n",temp1->getName(),temp1->getcharValue());
                                            }
                                          }
                                          tokenout<<"\n"<<"statement:pri LPAREN id RPAREN SEMICOLON"<<endl;
                                        }
     | RETURN expression SEMICOLON {tokenout<<"\n"<<"statement:Ireturn expression SEMICOLON"<<endl;delete $2;}
     ;
    
expression_statement  : SEMICOLON  {tokenout<<"\n"<<"expression_statement:SEMICOLON"<<endl;}   
      | expression SEMICOLON {$$=new SymbolInfo();
                              $$->setValue($1->getValue());
                              $$->setType($1->getType());
                              //printf("Now in exp_state rule exp_sem last exp value  %lf\n",$1->getValue());
                              //st->print_not_empty(tokenout<<"\n");
                              tokenout<<"\n"<<"expression_statement:expression SEMICOLON"<<endl;
                              delete $1;
                              } 
      |expression error{tokenout<<"\n"<<"expression_statement:expression error"<<endl;
                              //tokenout<<"\n"<<"Error: Semicolon missing at line "<<line_count<<endl;
                              errorCounter++;
                              delete $1;
                      }
      |error{
              //tokenout<<"\n"<<"Eror: Semicolon missing at line "<<line_count<<endl;
              errorCounter++;
            }
      ;
            
variable : ID    { //printf(" Now in variable rule Id first id name  %s\n",$1->getName());
                   
                   
                   
                   position pos=st->lookUp($1->getName());
                   if((pos.getI()==-1)||((pos.getI()!=-1)&&((st->getSymbol(pos))->getvarScope())!=nowType))
                   {
                    errorCounter++;
                    
                    tokenout<<"\n"<<"Error:    Variable "<<$1->getName()<<" has not declared yet "<<" at line ";
                    tokenout<<"\n"<<line_count<<endl;
                    $$=new SymbolInfo();
                    $$->setValue(-1);
                    
                   }
                   else
                   {
                      $$=st->getSymbol(pos); 
                      //printf("%d length from\n",$$->getLength());
                   }

                   //printf("Now in variable rule Id last id name and value %s %lf\n",$$->getName(),$$->getValue());
                   tokenout<<"\n"<<"variable: Id"<<endl<<$$->getName()<<"\n\n";
                 } 
   | ID LTHIRD expression RTHIRD {
                                   position pos=st->lookUp($1->getName());
                                   
                                   //temp1=(temp1->getArrayObject((int)$3->getValue()));
                                   //printf("In array %d\n",(int)$3->getValue());
                                   if($3->getValue()!=-1)
                                   {
                                   
                                   if((pos.getI()==-1)||((pos.getI()!=-1)&&((st->getSymbol(pos))->getvarScope())!=nowType))
                                   {
                                    tokenout<<"\n"<<"Error:    Variable "<<$1->getName()<<" has not declared yet "<<" at line ";
                                    tokenout<<"\n"<<line_count<<endl;
                                    errorCounter++;
                                   }
                                   else
                                   {
                                    SymbolInfo *temp1=st->getSymbol(pos);
                                    if(strcmp($3->getType(),"float")==0)
                                    {
                                        tokenout<<"\n"<<"Error:    Index can't be float at line "<<line_count<<endl;
                                        errorCounter++;
                                    }
                                    else if($3->getValue()>=temp1->getLength())
                                   {
                                     tokenout<<"\n"<<"Error:    Array index out of boundary error at line "<<line_count<<endl;
                                     errorCounter++;
                                   }
                                   else
                                   {
                                      $$=(temp1->getArrayObject((int)$3->getValue()));
                                   }
                                 }
                               }
                                 tokenout<<"\n"<<"variable: Id LTHIRD expression RTHIRD"<<endl<<$$->getName()<<"\n\n";
                                 delete $3;

                                  }
   ;
      
expression : logic_expression {$$=new SymbolInfo();
                              $$->setValue($1->getValue());
                              $$->setType($1->getType());
                              //printf("Now in exp rule logic_exp logic value  %lf\n",$1->getValue());
                              tokenout<<"\n"<<"expression:logic_expression"<<endl;
                              delete $1;
                              } 
     | variable ASSIGNOP logic_expression { //printf ("Now in exp rule variable first\n");
                                            $$=new SymbolInfo();
                                            $$->setValue(0);
                                            $$->setType("int");
                                            if(($3->getValue()!=-1)&&($1->getValue()!=-1))
                                            {
                                            
                                            //printf("Now in exp rule variable middle exp value  %lf\n",$3->getValue());
                                             if($1->getLength()!=0)
                                            {
                                              tokenout<<"\n"<<"Error:    Assign in an array "<<line_count<<endl;
                                              errorCounter++;
                                            }
                                            else if((strcmp($1->getType(),$3->getType())==0))
                                            {
                                              $$->setValue(1);
                                              $1->setValue((int)$3->getValue());
                                            }
                                            else if($1->getLength()!=0)
                                            {
                                              tokenout<<"\n"<<"Error:    Assign in an array "<<line_count<<endl;
                                              errorCounter++;
                                            }
                                            else
                                            {
                                                tokenout<<"\n"<<"Error:    Type mismatch error at line "<<line_count<<endl;
                                                errorCounter++;
                                            }
                                          }
                                           //printf("Now in exp rule variable middle var value  %lf\n",$1->getValue());
                                           //printf("Now in exp rule variable last var name %s %lf",$1->getName(),$1->getValue());
                                           tokenout<<"\n"<<"expression:variable assignop logic_expression"<<endl<<"\n\n";
                                           st->print_not_empty(tokenout);
                                           tokenout<<"\n\n";
                                           delete $3;
                                           

                                          }  

     ;
      
logic_expression : rel_expression  {$$=new SymbolInfo();
                                    $$->setValue($1->getValue());
                                    $$->setType($1->getType());
                                    //printf("Now in logic_exp rule rel_exp last  %lf\n",$1->  getValue());
                                    tokenout<<"\n"<<"logic_expression:rel_expression"<<endl;
                                    delete $1;
                                    } 
     | rel_expression LOGICOP rel_expression{
                                              //printf("%s\n",$2);
                                              char *temp2=$2->getName();
                                              $$=new SymbolInfo();
                                              $$->setType("int");
                                              if(strcmp(temp2,"&&")==0)
                                                 {
                                                  $$=new SymbolInfo();
                                                  $$->setValue(($1->getValue())&&($3->getValue()));
                                                 }
                                                 else if(strcmp(temp2,"||")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())||($3->getValue()));

                                                 }
                                                 /*else if(strcmp($2,"!")==0)
                                                 {
                                                  $$=new SymbolInfo();
                                                  $$->setValue(($1->getValue())!($3->getValue()));
                                                 }*/
                                                 tokenout<<"\n"<<"logic_expression:rel_expression LOGICOP rel_expression"<<endl;
                                                 delete $1;
                                                 delete $3;
                                                 delete $2;
                                                 
                                                 
                                              }  ;
     
      
rel_expression  : simple_expression  {
                                       $$=new SymbolInfo();
                                      $$->setValue($1->getValue());
                                      $$->setType($1->getType());
                                      //printf("Now in rel_exp rule simp_exp last   %lf\n",$1->getValue());
                                      tokenout<<"\n"<<"rel_expression: simple_expression"<<endl;
                                      delete $1;
                                      }
    | simple_expression RELOP simple_expression {//printf("Now in rel_exp rule simp_exp_relop last\n");
                                                  char *temp2=$2->getName();
                                                  $$=new SymbolInfo();
                                                  $$->setType("int");
                                                  
                                                 if(strcmp(temp2,">")==0)
                                                 {
                                                  //printf("\n first\n");
                                                  //printf("here var %d",($1->getValue())>($3->getValue()));
                                                  
                                                  $$->setValue(($1->getValue())>($3->getValue()));
                                                 }
                                                 else if(strcmp(temp2,"<")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())<($3->getValue()));

                                                 }
                                                 else if(strcmp(temp2,"<=")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())<=($3->getValue()));
                                                 }
                                                 else if(strcmp(temp2,">=")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())>=($3->getValue()));
                                                 }
                                                 else if(strcmp(temp2,"==")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())==($3->getValue()));
                                                 }
                                                 else if(strcmp(temp2,"!=")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())!=($3->getValue()));
                                                 }
                                                 tokenout<<"\n"<<"rel_expression: simple_expression RELOP simple_expression"<<endl;
                                                 delete $1;
                                                 delete $3;
                                                 delete $2;
                                                };
    ;
        
simple_expression : term {$$=new SymbolInfo();
                          $$->setValue($1->getValue());
                          $$->setType($1->getType());
                          //printf("Now in simp_exp rule term last %lf\n",$1->getValue());
                          tokenout<<"\n"<<"simple_expression:term"<<endl;
                          delete $1;
                          }
      | simple_expression ADDOP term {
                                      //printf("Now in simp_exp rule Addop last  %lf\n",$1->getValue());
                                      char *temp2=$2->getName();
                                      //printf("(%s)\n",temp2);
                                      if((strcmp(temp2,"-"))==0)
                                      {
                                        $$=new SymbolInfo();
                                        $$->setValue($1->getValue()-$3->getValue());
                                      }
                                      else
                                      {
                                        $$=new SymbolInfo();
                                        $$->setValue($1->getValue()+$3->getValue());
                                        if((strcmp($1->getType(),"float")==0)||(strcmp($3->getType(),"float")==0))
                                        {
                                          $$->setType("float");
                                        }
                                        $$->setType("int");
                                      }
                                      tokenout<<"\n"<<"simple_expression:simple_expression addop term"<<endl;
                                      delete $1;
                                      delete $3;
                                      delete $2;
                                    }
      ;
          
term :  unary_expression  {
                           $$=new SymbolInfo();
                           $$->setValue($1->getValue());
                           $$->setType($1->getType());

                           //printf("Now in term rule u_ex last  %lf\n",$1->getValue());
                           tokenout<<"\n"<<"term:unary_expression"<<endl;
                           delete $1;
                           }
     |  term MULOP unary_expression{//printf("Now in term rule term_mulop first\n");
                                   
                                     char *temp2=$2->getName();
                                     //printf("(%s)\n",temp2);
                                     if($1->getValue()!=-1)
                          {
                                    if((strcmp(temp2,"*"))==0)
                                    {
                                      $$=new SymbolInfo();
                                      $$->setValue(($1->getValue())*($3->getValue()));
                                      if((strcmp($1->getType(),"float")==0)||((strcmp($3->getType(),"float")==0)))
                                        {
                                          $$->setType("float");
                                        }
                                        else
                                        { 
                                          $$->setType("int");
                                        }
                                    }
                                    else
                                    {
                                      if((strcmp($1->getType(),"int")==0)&&(strcmp($3->getType(),"int")==0))
                                      {
                                        //printf("here1");
                                        $$=new SymbolInfo();
                                        $$->setValue(((int)$1->getValue())%((int)$3->getValue()));
                                        $$->setType("int");

                                      }
                                      else
                                      { 
                                        //printf("here2");
                                        tokenout<<"\n"<<"Error:    Remainder with non int  at line "<<line_count<<endl;
                                        errorCounter++;
                                        $$=new SymbolInfo();
                                        $$->setType("int");
                                        $$->setValue(-1);
                                      }
                                      tokenout<<"\n"<<"term:term mulop unary_expression"<<endl;
                                  }


                                }
                                      else
                                      {
                                        $$=new SymbolInfo();
                                        $$->setType("int");
                                        $$->setValue(-1);
                                      }

                                    delete $2;
                                    delete $1;
                                    delete $3;
                                    tokenout<<"\n"<<"term:term mulop unary_expression"<<endl;
                                    //printf("Now in term rule term_mulop last  %lf\n",$1->getValue());
                                  }
     ;

unary_expression : ADDOP unary_expression {
                                            char *temp2=$1->getName();
                                      //printf("(%s) %lf\n",temp2,$2->getValue());
                                      if((strcmp(temp2,"-"))==0)
                                      {
                                        //printf("here\n");
                                        $$=new SymbolInfo();
                                        //printf("here\n");
                                        $$->setValue((-1)*($2->getValue()));
                                        $$->setType($2->getType());
                                        //printf("here\n");
                                      }
                                      else
                                      {
                                        $$=new SymbolInfo();
                                        $$->setValue((+1)*($2->getValue()));
                                        $$->setType($2->getType());
                                      }
                                      delete $2;
                                      delete $1;
                                      tokenout<<"\n"<<"unary_expression:ADDOP unary_expression"<<endl;
                                } 
     | NOT unary_expression {if($2->getValue()==0)
                                {
                                  $$=new SymbolInfo();
                                  $$->setValue($2->getValue()+1);
                                  $$->setType($2->getType());
                                }
                                else
                                {
                                  $$=new SymbolInfo();
                                  $$->setValue(0);
                                  $$->setType($2->getType());

                                }
                                delete $2;
                                tokenout<<"\n"<<"unary_expression:NOT unary_expression"<<endl;
                            }
     | factor {//printf("Now in u_ex rule factor first  %f\n",$1->getValue());
               $$=new SymbolInfo();
               $$->setValue($1->getValue());
               $$->setType($1->getType());
               
               
               //printf("Now in u_ex rule factor last %lf\n",$$->getValue());
               tokenout<<"\n"<<"unary_expression:factor"<<endl;
               }
     ;
  
factor  : variable   {    //printf("Now in factor rule variable first \n");
                           //$$=new SymbolInfo();
                           //$$->setValue($1->getValue());
                           $$=$1;
                           //printf("Now in factor rule variable last  %lf\n",$1->getValue());
                           tokenout<<"\n"<<"factor:variable"<<endl<<$1->getValue()<<"\n\n";
                      }
  | LPAREN expression RPAREN {$$=new SymbolInfo();
                               $$->setValue($1->getValue());
                                  $$->setType($1->getType());
                                  delete $1;
                                  tokenout<<"\n"<<"factor:LPAREN expression RPAREN"<<endl;
                                }
  | CONST_INT {//printf("Now in factor rule const_int first %d \n",$1);
                 $$=new SymbolInfo();
                 $$->setValue($1);
                 $$->setType("int");
                 
                 //printf("Now in factor rule const_int last %lf\n",$$->getValue());
                 tokenout<<"\n"<<"factor:CONST_INT"<<endl<<$$->getValue()<<"\n\n";
               }
  | CONST_FLOAT{ $$=new SymbolInfo();
                 $$->setValue($1);
                 $$->setType("float");
                 tokenout<<"\n"<<"factor:CONST_FLOAT"<<endl<<$$->getValue()<<"\n\n";
               }
  | CONST_CHAR {$$=new SymbolInfo();
                 $$->setcharValue(($1));
               $$->setType("char");
               tokenout<<"\n"<<"factor:CONST_CHAR"<<endl<<$1<<"\n\n";
               }
  | factor INCOP {$$->setValue($$->getValue()+1);
                   tokenout<<"\n"<<"factor:factor INCOP"<<endl<<$$->getValue()<<"\n\n";
                 }
  | factor DECOP {$$->setValue($$->getValue()-1);
                   tokenout<<"\n"<<"factor:factor DECOP"<<endl<<$$->getValue()<<"\n\n";
                 }
  |ILL_FORMED_NUMBER {tokenout<<"\n"<<"factor:ILL_FORMED_NUMBER "<<endl;
                       tokenout<<"\n"<<"Error : ILL formed number at line "<<line_count<<endl;
                       errorCounter++;
                       
                     }
  |TOO_MANY_DECIMAL_POINT{tokenout<<"\n"<<"factor:TOO_MANY_DECIMAL_POINT"<<endl;
                       tokenout<<"\n"<<"Error : TOO_MANY_DECIMAL_POINT at line "<<line_count<<endl;
                       errorCounter++;
                       
                       }
  ;
%%

int main(int argc,char *argv[])
{

  yydebug=1;
 tokenout.open("1305117_token.txt");
if(argc!=2){
    //printf("Please provide input file name and try again\n");
    return 0;
  }
  
  FILE *fin=fopen(argv[1],"r");
  if(fin==NULL){
    //printf("Cannot open specified file\n");
    return 0;
  }

  
        
  yyin=fin;
  yyparse();
  tokenout<<"\n"<<"                         SymbolTable:"<<endl;
  st->print_not_empty(tokenout);
  tokenout<<"Total lines : "<<line_count<<endl<<"Total errors : "<<errorCounter<<endl;
  tokenout.close();
  fclose(fin);
    
    exit(0);
}