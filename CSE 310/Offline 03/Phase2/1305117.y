
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
string alltemp="";
string showProc="OUTPUT PROC\n PUSH AX\nPUSH BX\nPUSH CX\nPUSH DX\nPUSH VAR1\n\nMOV DX,0\nMOV DIVISOR,10\nMOV CX,10000\nFIRST_DIVISION:\nDIV CX\n\\\
    CMP AX,0\nJNE SECOND_DIVISION\nMOV VAR1,DX\nMOV DX,0\nMOV AX,CX \nDIV DIVISOR\nMOV CX,AX\nMOV AX,VAR1\nJMP FIRST_DIVISION \nSECOND_DIVISION:\n\
    MOV VAR1,DX\nMOV DL,AL \nADD DL,'0'\nMOV AH,2\nINT 21H\nMOV DX,0\nMOV AX,CX \nDIV DIVISOR\nMOV CX,AX \nCMP CX,0 \nJE END_OF_OUTPUT \nMOV DX,0\n\
    MOV AX,VAR1\nDIV CX\nJMP SECOND_DIVISION\nEND_OF_OUTPUT:\nMOV DL,0DH\nMOV AH,2\nINT 21H\nMOV DL,0AH\nINT 21H\nPOP VAR1\nPOP DX\nPOP CX\
   \nPOP BX\nPOP AX\nRET\nOUTPUT ENDP";
void yyerror(const char *s){
	//printf("%s\n",s);
  tokenout<<"\n"<<"Eror: "<<s<<"  at line "<<line_count<<endl;
}

int yylex(void);

int labelCount=0;
int tempCount=0;


char *newLabel()
{
  char *lb= new char[4];
  strcpy(lb,"L");
  char b[3];
  sprintf(b,"%d", labelCount);
  labelCount++;
  strcat(lb,b);
  return lb;
}

char *newTemp()
{
  char *t= new char[4];
  strcpy(t,"t");
  char b[3];
  sprintf(b,"%d", tempCount);
  tempCount++;
  strcat(t,b);
  alltemp=alltemp+string(t)+" dw ?\n";
  return t;
}


%}

%token NEWLINE NUMBER PLUS MINUS SLASH ASTERISK ASSIGNOP NOT SEMICOLON COMMA LCURL RCURL LTHIRD RTHIRD INCOP DECOP IF ELSE FOR WHILE CHAR RETURN VOID MAIN PRINTLN DO SWITCH DEFAULT BREAK CASE CONTINUE

%union{ SymbolInfo * si;float fval;int ival;char *cval; store *sr;}

%token <fval> FLOAT;
%token <ival> INT; 
%type <si> factor simple_expression term unary_expression rel_expression logic_expression expression expression_statement statements
 statement compound_statement declaration_list var_declaration Program SEMICOLON ;
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
Program : INT MAIN LPAREN RPAREN compound_statement
		{
			tokenout<<"\n"<<"Program : Int main lparen rparen compound_statement"<<endl;
			$$=new SymbolInfo();
			$$->gcode=$5->gcode;
			ofstream fout;
			fout.open("code.asm");
			fout << $$->gcode;
		}
         ;



compound_statement : LCURL var_declaration statements RCURL {//printf("Now in comp_state \n");
                                                              tokenout<<"\n"<<"compound_statement: Lcurl var declaration statements RCURL"<<endl;
                                                              $$=new SymbolInfo();
    	                                                      $$->gcode=".model small\n.stack 100H\n.data\n"+alltemp+$2->gcode+".code\n"+showProc+"\nMAIN PROC\n"+$3->gcode+"main endp\n";
                                                            }
       | LCURL statements RCURL{//printf("compound_statement\n");
                                  tokenout<<"\n"<<"compound_statements:Lcurl statements RCURL"<<endl;
                                  $$=new SymbolInfo();
                                  $$->gcode=$2->gcode;
                               }
       | LCURL RCURL{tokenout<<"\n"<<"compound_statements:Lcurl RCURL"<<endl;$$=new SymbolInfo();}
       ;

       
var_declaration : type_specifier declaration_list SEMICOLON {//printf("Now in var_dec \n");
                                                              tokenout<<"\n"<<"var_declaration: type_specifier declaration_list SEMICOLON"<<endl;
                                                              $$=new SymbolInfo();
                                                              $$->gcode=$2->gcode;
                                                            }
    |  var_declaration type_specifier declaration_list SEMICOLON
    {
    	tokenout<<"\n"<<"var_declaration:var_declaration type_specifier declaration_list SEMICOLON"<<endl;
    	$$=new SymbolInfo();
    	$$->gcode=$1->gcode+$3->gcode;
    }
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
                                                 $$=new SymbolInfo();
												 $$->gcode=$1->gcode+string($3->getName())+" dw " + "?\n";
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
                                                                  $$=new SymbolInfo();
                                                                  $$->gcode=$1->gcode+string(temp->getName())+" dw ";
                                                                  for(int i=0;i<$5-1;i++)
																	{
																				$$->gcode = $$->gcode+"?, " ;
																	}
																	$$->gcode=$$->gcode+"?\n";

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
              $$=new SymbolInfo();
						$$->gcode=string($1->getName())+" dw " + "?\n";
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
                                     $$=new SymbolInfo();
                                     $$->gcode=string(temp->getName())+" dw ";
									for(int i=0;i<$3-1;i++)
									{
											$$->gcode = $$->gcode+"?, " ;
									}
										$$->gcode=$$->gcode+"?\n";
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
                          $$=new SymbolInfo();
     							$$->gcode=$1->gcode;
     							//printf("here");
     							delete $1;
     							//printf("here");
                        }
     | statements statement {//printf("Now in Statemnts statements  first\n");
                              tokenout<<"\n"<<"statements:statements statement"<<endl;
                              //printf("Now in Statemnts statements  last\n");
                                $$=new SymbolInfo();
     							$$->gcode=$1->gcode+$2->gcode;
     							//printf("here");

     							delete $1;
     							delete $2;
                            }
     ;


statement  : expression_statement {//printf("Now in statement expstate first\n");
                                      tokenout<<"\n"<<"statement:exprssion_statement"<<endl;
                                  }
     | compound_statement 
     {
     	tokenout<<"\n"<<"statement:compound_statement"<<endl;
     	$$=new SymbolInfo();
     	$$->gcode=$1->gcode;
     }
     | FOR LPAREN expression_statement expression_statement expression RPAREN statement 
     {
     	tokenout<<"\n"<<"statement:for lparen exprssion_statement exprssion_statement expression RPAREN"<<endl;
     	$$=new SymbolInfo();
     	char *label1=newLabel();
     	char *label2=newLabel();
     	$$->gcode=$3->gcode+string(label1)+":\n"+$4->gcode+"\nmov ax,"+string($4->getName())+"\ncmp ax,";
     	$$->gcode=$$->gcode+"1\n"+"jne "+string(label2)+"\n";
     	$$->gcode=$$->gcode+$7->gcode+$5->gcode+"jmp "+string(label1)+"\n"+string(label2)+":\n";

     	delete $3;
     }
     | IF LPAREN expression RPAREN statement   
     {
     	tokenout<<"\n"<<"statement:IF LPAREN expression RPAREN statement"<<endl;
     				$$=new SymbolInfo();
     				char *label=newLabel();
					$$->gcode=$$->gcode+"mov ax, "+string($3->getName())+"\n";
					$$->gcode=$$->gcode+"cmp ax, 1\n"+"jne "+string(label)+"\n"+$5->gcode+string(label)+":\n";
     	delete $3;
     } %prec LOWER_THAN_ELSE;
     | IF LPAREN expression RPAREN statement ELSE statement
     {
     	tokenout<<"\n"<<"statement:IF LPAREN expression RPAREN statement else statement"<<endl;
     	$$=new SymbolInfo();
     				char *label1=newLabel();
     				char *label2=newLabel();
					$$->gcode=$$->gcode+"mov ax, "+string($3->getName())+"\n";
					$$->gcode=$$->gcode+"cmp ax, 1\n"+"jne "+string(label1)+"\n"+$5->gcode+"jmp "+string(label2);
					$$->gcode=$$->gcode+string(label1)+":\n"+$7->gcode+string(label2)+":\n";
     	delete $3;
     }
     | WHILE LPAREN expression RPAREN statement 
     {
     	tokenout<<"\n"<<"statement:WHILE LPAREN expression RPAREN statement"<<endl; 
     	$$=new SymbolInfo();
     				char *label1=newLabel();
     				char *label2=newLabel();
     				$$->gcode=$$->gcode+$2->gcode+string(label1)+":\n mov ax,"+string($2->getName())+"cmp ax,1\n"+"jne ";
     				$$->gcode=$$->gcode+string(label2)+$5->gcode+"jmp "+string(label1)+"\n"+string(label2)+":\n";
     	delete $3;
     }
     | PRINTLN LPAREN ID RPAREN SEMICOLON {
                                             printf(" here\n");
                                             position pos=st->lookUp($3->getName());

                                             if((pos.getI()==-1)||((pos.getI()!=-1)&&((st->getSymbol(pos))->getvarScope())!=nowType))
                                             {
                                              tokenout<<"\n"<<"Error:    Trying to print undeclared id "<<$3->getName()<<"at line "<<line_count<<endl;
                                              errorCounter++;
                                             }
                                            else
                                            {
                                            	//printf(" here");
                                             SymbolInfo *temp1=st->getSymbol(pos);
                                              if(strcmp(temp1->getType(),"int")==0)
                                              {

                                                //printf("Now here");
                                                printf("\n ID %s  value %d\n",temp1->getName(),(int)temp1->getValue());
                                                //printf("now here1");
                                                
                                              }
                                            else if(strcmp($3->getType(),"float")==0)
                                            {
                                              //printf("now here1");
                                              printf("\n ID %s  value %f\n",temp1->getName(),temp1->getValue());
                                              
                                            }
                                            else if((strcmp($3->getType(),"char"))==0)
                                            {
                                            //printf("now here3");
                                              printf("\n ID %s  value %s\n",temp1->getName(),temp1->getcharValue());

                                            }
                                            
                                            $$=new SymbolInfo();

                                            $$->gcode=$$->gcode+"push ax\nmov ax,"+string($3->getName())+"\ncall output\npop ax\n";
                                          }
                                          tokenout<<"\n"<<"statement:pri LPAREN id RPAREN SEMICOLON"<<endl;
                                        }
     | RETURN expression SEMICOLON {tokenout<<"\n"<<"statement:return expression SEMICOLON"<<endl;
     									$$=new SymbolInfo();
     									$$->setValue($2->getValue());
                              			$$->setType($2->getType());
     								    $$->gcode=$2->gcode+"mov ah,4ch\n int 21h\n";
     							   		delete $2;}
     ;
    
expression_statement  : SEMICOLON  {tokenout<<"\n"<<"expression_statement:SEMICOLON"<<endl;$$->gcode="";}   
      | expression SEMICOLON {$$=new SymbolInfo();
                              $$->setValue($1->getValue());
                              $$->setType($1->getType());
                              //printf("Now in exp_state rule exp_sem last exp value  %lf\n",$1->getValue());
                              //st->print_not_empty(tokenout<<"\n");
                              tokenout<<"\n"<<"expression_statement:expression SEMICOLON"<<endl;
                              $$->gcode=$1->gcode;
                              $$->setName($1->getName());
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
                                      $$->gcode=$1->gcode;
                                      $$->setName($1->getName());
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
                              $$->gcode=$1->gcode;
                              $$->setName($1->getName());
                             // printf("%s",$1->getName());
                              tokenout<<"\n"<<"expression:logic_expression"<<endl;
                              delete $1;
                              } 
     | variable ASSIGNOP logic_expression { //printf ("Now in exp rule variable first\n");
                                            $$=new SymbolInfo();
                                            $$->setValue(0);
                                            $$->setType("int");
                                            $$->gcode=$3->gcode+$1->gcode+"mov ax, "+string($3->getName())+"\n";

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
                                              $1->setValue($3->getValue());
                                              if($1->getindexholder()==-9999)
                                              {
                                              	$$->gcode=$$->gcode+"mov "+string($1->getName())+",ax\n";
                                              	$$->setindexholder();
                                              	
                                              }
                                              else
                                              {
                                              	$$->gcode=$$->gcode+"lea di, "+string($1->getName())+"\n";
                                              	for(int i=0;i<2;i++)
                           						{
					            					std::stringstream sstm;
                           							sstm<<$1->getindexholder();
                                					$$->gcode=$$->gcode+"add di,"+sstm.str()+"\n";

	                       						}
	                       						$$->gcode=$$->gcode+"move [di],ax \n";
	                       						$$->setindexholder($$->getindexholder());

                                              }
                                              
                                            }
                                            else if((strcmp($1->getType(),"int")==0)&&(strcmp($3->getType(),"float")==0))
                                            {
                                              $$->setValue(1);
                                              $1->setValue((int)$3->getValue());
                                              tokenout<<"\n"<<"Warning :precission loss at line "<<line_count<<endl;
                                            }
                                            else if((strcmp($1->getType(),"float")==0)&&(strcmp($3->getType(),"int")==0))
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
                                    $$->gcode=$1->gcode;
                                    $$->setName($1->getName());
                                    //printf("%s",$1->getName());
                                    delete $1;
                                    } 
     | rel_expression LOGICOP rel_expression{
                                              //printf("%s\n",$2);
                                              char *temp2=$2->getName();
                                              $$=new SymbolInfo();
                                              $$->setType("int");
                                              $$->gcode=$1->gcode+$3->gcode;
                                              char * temp=newTemp();
                                              char *label1=newLabel();
                                              if(strcmp(temp2,"&&")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())&&($3->getValue()));
                                                  $$->gcode=$$->gcode+"mov ax, "+string($1->getName())+"cmp ax"+",0\n";
                                                  $$->gcode=$$->gcode+"je "+string(label1)+"\n"+"mov ax, ";
                                                  $$->gcode=$$->gcode+string($3->getName())+"cmp ax"+",0\n";
                                                  $$->gcode=$$->gcode+"je "+string(label1)+"\n"+"mov "+string(temp)+",1\n";
                                                  $$->gcode=$$->gcode+string(label1)+":\n"+"mov "+string(temp)+",0\n";
                                                  $$->setName(temp);



                                                  

                                                 }
                                                 else if(strcmp(temp2,"||")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())||($3->getValue()));
                                                  $$->setValue(($1->getValue())&&($3->getValue()));
                                                 $$->gcode=$$->gcode+"mov ax, "+string($1->getName())+"cmp ax"+",1\n";
                                                  $$->gcode=$$->gcode+"je "+string(label1)+"\n"+"mov ax, ";
                                                  $$->gcode=$$->gcode+string($3->getName())+"cmp ax"+",1\n";
                                                  $$->gcode=$$->gcode+"je "+string(label1)+"\n"+"mov "+string(temp)+",0\n";
                                                  $$->gcode=$$->gcode+string(label1)+":\n"+"mov "+string(temp)+",1\n";
                                                  $$->setName(temp);

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
                                      $$->setName($1->getName());
                                      $$->gcode=$1->gcode;
                                      //printf("Now in rel_exp rule simp_exp last   %lf\n",$1->getValue());
                                      tokenout<<"\n"<<"rel_expression: simple_expression"<<endl;
                                      delete $1;
                                      }
    | simple_expression RELOP simple_expression {//printf("Now in rel_exp rule simp_exp_relop last\n");
                                                  char *temp2=$2->getName();
                                                  $$=new SymbolInfo();
                                                  $$->setType("int");
                                                  $$->gcode=$1->gcode+$3->gcode+"mov ax, "+string($1->getName())+"\n";
                                                  $$->gcode=$$->gcode+"cmp ax,"+string($3->getName())+"\n";
                                                  char *temp=newTemp();
                                                  char *label1=newLabel();
                                                  char *label2=newLabel();

                                                  
                                                 if(strcmp(temp2,">")==0)
                                                 {
                                                  //printf("\n first\n");
                                                  //printf("here var %d",($1->getValue())>($3->getValue()));
                                                  
                                                  $$->setValue(($1->getValue())>($3->getValue()));
                                                  $$->gcode=$$->gcode+"jg "+string(label1)+"\n";
                                                  
                                                 }
                                                 else if(strcmp(temp2,"<")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())<($3->getValue()));
                                                  $$->gcode=$$->gcode+"jl "+string(label1)+"\n";
                                                  

                                                 }
                                                 else if(strcmp(temp2,"<=")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())<=($3->getValue()));
                                                  $$->gcode=$$->gcode+"jle "+string(label1)+"\n";
                                                  
                                                 }
                                                 else if(strcmp(temp2,">=")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())>=($3->getValue()));
                                                  $$->gcode=$$->gcode+"jge "+string(label1)+"\n";
                                                  
                                                 }
                                                 else if(strcmp(temp2,"==")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())==($3->getValue()));
                                                  $$->gcode=$$->gcode+"je "+string(label1)+"\n";
                                                  
                                                 }
                                                 else if(strcmp(temp2,"!=")==0)
                                                 {
                                                  
                                                  $$->setValue(($1->getValue())!=($3->getValue()));
                                                  $$->gcode=$$->gcode+"jne "+string(label1)+"\n";
                                                  
                                                 }
                                                 $$->gcode=$$->gcode+"mov "+string(temp)+",0\n"+"jmp "+string(label2)+"\n";
                                                 $$->gcode=$$->gcode+string(label1)+":\nmov"+string(temp)+",1\n"+string(label2);
                                                 $$->gcode=$$->gcode+":\n";
                                                
                                                 $$->setName(temp);
                                                 tokenout<<"\n"<<"rel_expression: simple_expression RELOP simple_expression"<<endl;
                                                 delete $1;
                                                 delete $3;
                                                 delete $2;
                                                };
    ;
        
simple_expression : term {$$=new SymbolInfo();
                          $$->setValue($1->getValue());
                          $$->setType($1->getType());
                          $$->setName($1->getName());
                          //printf("Now in simp_exp rule term last %lf\n",$1->getValue());
                          tokenout<<"\n"<<"simple_expression:term"<<endl;
                          $$->gcode=$1->gcode;
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
                                        $$->gcode=$1->gcode+$3->gcode+"mov ax, "+string($1->getName())+"\n"+"sub ax, "+string($3->getName())+"\n";
                                        char* temp=newTemp();
                                        $$->gcode=$$->gcode+"mov "+string(temp)+",ax\n";
                                        $$->setName(temp);
                                        
                                      }
                                      else
                                      {
                                        $$=new SymbolInfo();
                                        $$->setValue($1->getValue()+$3->getValue());
                                        
                                        
                                        
                                        if((strcmp($1->getType(),"float")==0)||(strcmp($3->getType(),"float")==0))
                                        {
                                          $$->setType("float");
                                        }
                                        $$->gcode=$1->gcode+$3->gcode+"mov ax, "+string($1->getName())+"\n"+"add ax, "+string($3->getName())+"\n";
                                        char* temp1=newTemp();
                                        $$->gcode=$$->gcode+"mov "+string(temp1)+",ax\n";
                                        $$->setType("int");
                                        $$->setName(temp1);
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
                           $$->gcode=$1->gcode;
                           $$->setName($1->getName());
                           //printf("Now in term rule u_ex last  %lf\n",$1->getValue());
                           tokenout<<"\n"<<"term:unary_expression"<<endl;
                           delete $1;
                           }
     |  term MULOP unary_expression{//printf("Now in term rule term_mulop first\n");
                                   
                                     char *temp2=$2->getName();
                                     //printf("(%s)\n",temp2);
                                     if($1->getValue()!=-1)
                          {          $$=new SymbolInfo();
                                     

                          			$$->gcode="mov ax,"+string($1->getName())+"\n"+"mov bx,"+string($3->getName())+"\n";
                                    if((strcmp(temp2,"*"))==0)
                                    {
                                      
                                      $$->setValue(($1->getValue())*($3->getValue()));
                                      if((strcmp($1->getType(),"float")==0)||((strcmp($3->getType(),"float")==0)))
                                        {
                                          $$->setType("float");
                                        }
                                        else
                                        { 
                                          $$->setType("int");
                                        }
                                      
                                      char *temp=newTemp();
                                      $$->gcode=$$->gcode+$1->gcode+$3->gcode+"mul bx\n mov "+string(temp)+",ax\n";
                                      $$->setName(temp);
                                    }
                                    else if((strcmp(temp2,"/"))==0)
                                    {
                                     if($3->getValue()!=0)
                                     {
                                        
                                        $$->setValue(($1->getValue())/($3->getValue()));
                                        $$->setType("float");
                                        
                                        char *temp=newTemp();
                                       $$->gcode=$$->gcode+"mov dx,0\n"+$1->gcode+$3->gcode+"div bx\n"+"mov "+string(temp)+", ax\n";
                                       $$->setName(temp);
                                      }
                                      else
                                      {
                                        tokenout<<"\n"<<"Error:    Can't divide by zero "<<line_count<<endl;
                                        errorCounter++;
                                        $$=new SymbolInfo();
                                        $$->setType("int");
                                        $$->setValue(-1);
                                      }
                                    }
                                    else if((strcmp(temp2,"%"))==0)
                                    {
                                      if((strcmp($1->getType(),"int")==0)&&(strcmp($3->getType(),"int")==0))
                                      {
                                        //printf("here1");
                                        
                                        $$->setValue(((int)$1->getValue())%((int)$3->getValue()));
                                        $$->setType("int");
                                        char *temp=newTemp();
                                       $$->gcode=$$->gcode+"mov dx,0\n"+$1->gcode+$3->gcode+"div bx\n"+"mov "+string(temp)+", dx\n";
                                       $$->setName(temp);
                                        

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
                                        
                                        $$->gcode="neg "+string($2->getName())+"\n";
                                        $$->setName($2->getName());
                                        
                                        
                                      }
                                      else
                                      {
                                        $$=new SymbolInfo();
                                        $$->setValue((+1)*($2->getValue()));
                                        $$->setType($2->getType());
                                        $$->gcode=$1->gcode;
                                        $$->setName($2->getName());
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
                                char *temp=newTemp();
                                $$->gcode="mov ax,"+string($2->getName())+"\n"+"not ax\n"+"mov "+string(temp)+",ax\n";
                                $$->setName(temp);
                                


                                delete $2;
                                tokenout<<"\n"<<"unary_expression:NOT unary_expression"<<endl;
                            }
     | factor {//printf("Now in u_ex rule factor first  %f\n",$1->getValue());
               $$=new SymbolInfo();
               $$->setValue($1->getValue());
               $$->setType($1->getType());
               $$->setName($1->getName());
               $$->gcode=$1->gcode;
               
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
                           if($1->getindexholder()!=-9999)
                           {

                           $$->gcode="lea di,"+string($1->getName())+"\n";
                           for(int i=0;i<2;i++)
                           {
					            std::stringstream sstm;
                           		sstm<<$1->getindexholder();
                                $$->gcode=$$->gcode+"add di,"+sstm.str()+"\n";

	                       }
	                       char *temp= newTemp();
	                       $$->gcode=$$->gcode+"mov "+string(temp)+", [di]\n";
	                       $$->setName(temp);
	                       $$->setindexholder();
	                       
	                       }
							

                      }
  | LPAREN expression RPAREN {$$=new SymbolInfo();
                               $$->setValue($1->getValue());
                                  $$->setType($1->getType());
                                  delete $1;
                                  $$->gcode=$1->gcode;
                                  tokenout<<"\n"<<"factor:LPAREN expression RPAREN"<<endl;
                                }
  | CONST_INT {//printf("Now in factor rule const_int first %d \n",$1);
                 $$=new SymbolInfo();
                 $$->setValue($1);
                 $$->setType("int");
                 std::stringstream sstm;
                 sstm<<$1;
                 char *temp=(char*)sstm.str().c_str();
                 $$->setName(temp);
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
  | variable INCOP {$1->setValue($1->getValue()+1);
  					$$=new SymbolInfo();
  					$$->gcode=$1->gcode+"inc "+string($1->getName())+"\n";
                    $$->setName($1->getName());
                    $$->setType($1->getType());
                   tokenout<<"\n"<<"factor:factor INCOP"<<endl<<$$->getValue()<<"\n\n";
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