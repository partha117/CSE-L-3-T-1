#include<cstdio>
#include<string.h>
#include<iostream>
#include<sstream>
#include <fstream>
#include <cstdlib>
#define NULL_VALUE 0
using namespace std;

class  store{
    
    
public:
    store()
    {
        this->dvalue=0;
        this->ivalue=0;
        this->cvalue=0;
        ////printf("created\n");
    }
    void setdvalue(double v)
    {
        store::dvalue=v;
    }
    
    double getdvalue()
    {
        return dvalue;
    }
    int getivalue()
    {
        return ivalue;
    }
    char* getcvalue()
    {
        return cvalue;
    }
    void setivalue(int v)
    {
        store::ivalue=v;
    }
    void setcvalue(char* v)
    {
        store::cvalue=v;
    }

    string code;
    double  dvalue;
    int ivalue;
    char * cvalue;
    
};

class SymbolInfo
{
public:
    SymbolInfo()// Used as size  is taken later
    {
        name="";

    }
    SymbolInfo(char*  type1,char* name1,int length1=0)
    {
        if(length1>0)
        {
            
            this->arr=new SymbolInfo[length1];
            length=length1;
            name=(char*)malloc(sizeof(char)*100);
            type=(char*)malloc(sizeof(char)*100);
            strcpy(name,name1);
            strcpy(type,type1);
            
            for(int i=0;i<length1;i++)
            {
                arr[i].setType(type1);
                arr[i].setValue(-99999);
                arr[i].setindexholder(i);
            }
          
        }
        else
        {        
        name=(char*)malloc(sizeof(char)*100);
        type=(char*)malloc(sizeof(char)*100);
        strcpy(name,name1);
        strcpy(type,type1);
        this->next= NULL_VALUE;
        this->value=-9999;
        length=0;
        }
        
    
    }

    char* getType()
    {
        return type;
    }
    char* setType(char * type1)
    {
        type=(char*)malloc((sizeof(char))*(strlen(type1)+2));
        strcpy(type,type1);
    }
    void setName(char* name1)
    {
        name=(char*)malloc(sizeof(char)*100);
        strcpy(name,name1);
        
    }
    char* getName()
    {
        //cout<<"from header "<<name<<endl;
        return name;
    }

    SymbolInfo *getNext() const {
        return next;
    }
    SymbolInfo getarrElement(int a) {
        if((a>0)&&(a<length))
        {
            return arr[a];
        }
        SymbolInfo as;
        return as;
    }

    void setNext(SymbolInfo *next) {
        SymbolInfo::next = next;
    }
    void setValue(float value) {
        SymbolInfo::value = value;
    }
    float getValue()
    {
        return value;
    }

    int getLength()
    {
        return length;
    }
    void setCode(char* code) {
        SymbolInfo::code = code;
        //strcpy(this->code,code);
    }
    char* getCode()
    {
        return code;
    }
    void setcharValue(char *c)
    {
        charvalue=(char*)malloc((sizeof(char)*strlen(c)));
        strcpy(charvalue,c);

    }
    char* getcharValue()
    {
        return charvalue;
    }
    SymbolInfo* getArrayObject(int a)
    {

        return &arr[a];
    }
    void setvarScope(int a)
    {
        varScope=a;
    }
    int getvarScope()
    {
        return varScope;
    }
    int getindexholder()
    {
        return indexholder;
    }
    void setindexholder()
    {
        indexholder=-9999;
    }
    void setindexholder(int i)
    {
        indexholder=i;
    }
string gcode;
private:
    char* type;
    char* name;
    SymbolInfo *next;
    char* charvalue;
    float value;
    char* code;
    int length;
    int indexholder=-9999;
    SymbolInfo* arr;
    int varScope;
};
class position
{
private:
    int i;
    int j;
    string type;
public:
    position(int i, int j) : i(i), j(j) {}

    int getI() const {
        return i;
    }

    void setI(int i) {
        position::i = i;
    }
    void setType(string t)
    {
        type=t;
    }
    string getType()
    {
        return type;
    }


    int getJ() const {
        return j;
    }

    void setJ(int j) {
        position::j = j;
    }
};
class SymbolTable
{
private:

    SymbolInfo **table;
    int maxSize;

    int hash(char*  st1) {
        unsigned long hash = 127;
        int c;
         char*st=(char*)malloc(sizeof(char)*100);
         ////printf("%s now here1\n",st1);
        strcpy(st,st1);
        ////printf("now here2\n");
        while (c = *st++)
        {
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
        }
        return (hash%maxSize);
    }
public:
    SymbolTable(int maxSize)// will have   maxSize number of row
    {
        this->maxSize=maxSize;

        table= new SymbolInfo*[maxSize];
        for(int i=0;i<maxSize;i++)
        {
            *(table+i)=NULL_VALUE;
        }
    }
    SymbolTable()// Used as size  is taken later
    {

    }
     ~SymbolTable()
    {
        SymbolInfo *temp,*temp1;
        for(int i=0;i<maxSize;i++)
        {
           temp=table[i];
            for(;temp!=NULL_VALUE;)
            {
               temp1=temp;
               temp=temp->getNext();
               delete(temp1);
            }
        }
        //cout<<"destructed"<<endl;
    }
    void setSize(int maxSize)
    {
        SymbolTable::maxSize = maxSize;
        this->maxSize=maxSize;

        table= new SymbolInfo*[maxSize];
        for(int i=0;i<maxSize;i++)
        {
            *(table+i)=NULL_VALUE;//necessary to find the end
        }
    }
    position  insert(SymbolInfo* input)
    {
        ////printf("from SymbolInfo insert %s\n",input->getName());
        position pos_temp=(position)lookUp(input->getName());


        if(pos_temp.getI()==-1)// checking is there another entry like this
        {
            int pos = hash(input->getName());//getting hash position
            if (table[pos] == NULL_VALUE) {//is it the first entry of that row
                table[pos] = (input);
                position cur(pos, 0);
                return cur;

            } else {
                SymbolInfo *temp = table[pos];
                int i = 1;
                for (; temp->getNext() != NULL_VALUE; i++) {
                    temp = temp->getNext();
                }
                temp->setNext(input);
                position cur(pos, i);
                return cur;
            }
        }
        else
        {
            //pos_temp.setI(-1);//it's a duplicate entry
            //pos_temp.setJ(-1);
            return  pos_temp;
        }
    }
    position  insert(char* info,char* Value)
    {   
        ////printf("%s %s now here\n",info,Value);
        SymbolInfo *input=new SymbolInfo(info,Value);
        position pos_temp=(position)lookUp(input->getName());

        if(pos_temp.getI()==-1)// checking is there another entry like this
        {
            int pos = hash(input->getName());//getting hash position
            if (table[pos] == NULL_VALUE) {//is it the first entry of that row
                table[pos] = (input);
                position cur(pos, 0);
                return cur;

            } else {
                SymbolInfo *temp = table[pos];
                int i = 1;
                for (; temp->getNext() != NULL_VALUE; i++) {
                    temp = temp->getNext();
                }
                temp->setNext(input);
                position cur(pos, i);
                return cur;
            }
        }
        else
        {
            //pos_temp.setI(-1);//it's a duplicate entry
            //pos_temp.setJ(-1);
            return  pos_temp;
        }
    }
    position lookUp(char* st)
    {
        int pos=hash(st);
        ////printf("from look up it is %s pos %d\n",st.c_str(),pos);

        SymbolInfo* temp=table[pos];
        //console_print();
        char* temp_name;
        int i=0;
        for(;(temp!= NULL_VALUE);i++)
        {  ////printf("First not null\n");

            temp_name=temp->getName();
            cout<<temp_name<<endl;
            if(strcmp(temp_name,st)==0)
            {
                position cur(pos,i);
                //cur.setType(temp->getType());
                ////printf("from header look ret %d\n",pos);
                return cur;
                ////printf("returned\n");
            }
            else
            {
                ////printf("here else\n");
                temp = temp->getNext();
                
            }
        }
        position cur(-1,-1);// as it is a duplicate entry
        ////printf("hfrom header ret null\n");
        return cur;
    }

    SymbolInfo* getSymbol(position cur)
    {
        
        
        SymbolInfo* now,*prev;// two pointer needed as it is a singly linked list
        now=prev=table[cur.getI()];
        for(int j=0;j!=cur.getJ();j++)
        {
            prev=now;
            now=now->getNext();
        }
        
        
        return  now;
    }

    void print(ofstream &fout)
    {
        for(int i=0;i<maxSize;i++)
        {
            fout<<i<<" -> ";
            if(table[i]!= NULL_VALUE)
            {
                SymbolInfo *temp = table[i];

                for (;temp!= NULL_VALUE;)
                {
                    //fout<<"<"<<temp->getValue()<<","<<temp->getName().c_str()<<"> ";
                    temp=temp->getNext();
                }
            }
            fout<<endl;
        }
        return;
    }
    void print_not_empty(ofstream &fout)
    {

        //printf("herer");
        fout.seekp(fout.tellp());
        fout<<endl;
        for(int i=0;i<maxSize;i++)
        {
            
            if(table[i]!= NULL_VALUE)
            {
                fout<<i<<" -> ";
                SymbolInfo *temp = table[i];

                for (;temp!= NULL_VALUE;)
                {
                    if(temp->getLength()!=0)
                    {
                        
                        fout<<"<"<<temp->getType()<<","<<temp->getName()<<","<<"{";
                        for(int j=0;j<temp->getLength();j++)
                        {
                            fout<<(temp->getArrayObject(j))->getValue()<<",";
                        }
                        fout<<"}"<<">";
                    }
                    else
                    {
                        fout<<"<"<<temp->getType()<<","<<temp->getName()<<","<<temp->getValue()<<">";
                        
                    }
                    temp=temp->getNext();
                }
                fout<<endl;
            }
         
            
        }
        fout<<endl;
        return;
    }
    void console_print()
    {
        
        cout<<endl;
        for(int i=0;i<maxSize;i++)
        {
            
            if(table[i]!= NULL_VALUE)
            {
                cout<<i<<" -> ";
                SymbolInfo *temp = table[i];

                for (;temp!= NULL_VALUE;)
                {
                    cout<<"<"<<temp->getValue()<<","<<temp->getType()<<" ,"<<temp->getName()<<"> ";
                    temp=temp->getNext();
                }
                cout<<endl;
            }
         
            
        }
        cout<<endl;
        return;
    }
    position Delete(char* st)
    {
        position cur=lookUp(st);
        if(cur.getI()==-1)// Checking the value is it exists
        {
            return cur;
        }
        SymbolInfo* now,*prev;// two pointer needed as it is a singly linked list
        now=prev=table[cur.getI()];
        for(int j=0;j!=cur.getJ();j++)
        {
            prev=now;
            now=now->getNext();
        }
        if(cur.getJ()==0)
        {
            table[cur.getI()]=now->getNext();
        }
        prev->setNext(now->getNext());
        delete(now);
        return  cur;
    }
};
/*void func()
{
    ifstream myfile ("input.txt");
    SymbolTable st;
    bool first=true;
    string command,info,value;
    if (myfile.is_open())
    {
        while ( myfile.eof()==false )
        {
                if(first)
                {
                    int s;
                    myfile>>s;
                    st.setSize(s);
                    first=false;
                }
                myfile>>command;
                if(command.compare("I")==0)
                {
                    myfile>>value>>info;
                    SymbolInfo *si=new SymbolInfo(info,value);
                    position pos=(position)(st.insert(si));
                    if(pos.getI()!=-1)
                    {
                        cout<<"<"<<value<<","<<info<<">  "<<"Inserted at position "<<(pos).getI()<<" , "<<pos.getJ()<<endl;
                    }
                    else
                    {
                         cout<<"<"<<value<<","<<info<<">   "<<"Already exist"<<endl;
                    }
                }
                else if(command.compare("P")==0)
                {
                    st.print();
                }
                else if(command.compare("D")==0)
                {
                    myfile>>value;
                    position pos=(position)st.Delete(value);
                    if(pos.getI()==-1)
                    {
                        cout<<value<<" Not Found"<<endl;
                    }
                    else
                    {
                        cout<<"Deleted from "<<(pos).getI()<<"  "<<pos.getJ()<<endl;
                    }
                }
                else if(command.compare("L")==0)
                {
                    myfile>>value;
                    position pos=(position)st.lookUp(value);
                    if(pos.getI()==-1)
                    {
                        cout<<value<<" Not Found"<<endl;
                    }
                    else
                    {
                        cout<<"<"<<value<<","<<pos.getType()<<" Found at "<<(pos).getI()<<"  "<<pos.getJ()<<endl;
                    }
                }
            }
        }
        myfile.close();
    }*/

