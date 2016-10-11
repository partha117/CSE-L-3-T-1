#include<cstdio>
#include<string>
#include<iostream>
#include<sstream>
#include <fstream>
#include <cstdlib>
#define NULL_VALUE 0
using namespace std;

class SymbolInfo
{
public:
    SymbolInfo(string type,string  name)
    {
        this->type=type;
        this->name=name;
        this->next= NULL_VALUE;
    }
    string getType()
    {
        return type;
    }
    string getName()
    {
        return name;
    }

    SymbolInfo *getNext() const {
        return next;
    }

    void setNext(SymbolInfo *next) {
        SymbolInfo::next = next;
    }

private:
    string type;
    string name;
    SymbolInfo *next;
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

    int hash(string  st1) {
        unsigned long hash = 127;
        int c;
        const char*st=st1.c_str();
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
            pos_temp.setI(-1);//it's a duplicate entry
            pos_temp.setJ(-1);
            return  pos_temp;
        }
    }
    position  insert(string info,string Value)
    {
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
            pos_temp.setI(-1);//it's a duplicate entry
            pos_temp.setJ(-1);
            return  pos_temp;
        }
    }
    position lookUp(string st)
    {
        int pos=hash(st);
        SymbolInfo* temp=table[pos];
        string temp_name;
        int i=0;
        for(;(temp!= NULL_VALUE);i++)
        {
            temp_name=temp->getName();
            if(temp_name.compare(st.c_str())==0)
            {
                position cur(pos,i);
                cur.setType(temp->getType());
                return cur;
            }
            else
            {
                temp = temp->getNext();
            }
        }
        position cur(-1,-1);// as it is a duplicate entry
        return cur;
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
                    fout<<"<"<<temp->getType().c_str()<<","<<temp->getName().c_str()<<"> ";
                    temp=temp->getNext();
                }
            }
            fout<<endl;
        }
        return;
    }
    void print_not_empty(ofstream &fout)
    {
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
                    fout<<"<"<<temp->getName().c_str()<<","<<temp->getType().c_str()<<"> ";
                    temp=temp->getNext();
                }
                fout<<endl;
            }
         
            
        }
        fout<<endl;
        return;
    }
    position Delete(string  st)
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

