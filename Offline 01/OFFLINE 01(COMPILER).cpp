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
        unsigned long hash = 123;
        int c;
        const char*st=st1.c_str();


        while (c = *st++)
        {
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
         }

        return (hash%maxSize);
    }

public:
    SymbolTable(int maxSize)
    {
        this->maxSize=maxSize;

        table= new SymbolInfo*[maxSize];
        for(int i=0;i<maxSize;i++)
        {
            *(table+i)=NULL_VALUE;
        }


    }
    SymbolTable()
    {

    }
    void setSize(int maxSize)
    {
        SymbolTable::maxSize = maxSize;
        this->maxSize=maxSize;

        table= new SymbolInfo*[maxSize];
        for(int i=0;i<maxSize;i++)
        {
            *(table+i)=NULL_VALUE;
        }
    }
    position  insert(SymbolInfo* input)
    {
        position pos_temp=(position)lookUp(input->getName());
        if(pos_temp.getI()==-1)
        {
            int pos = hash(input->getName());
            if (table[pos] == NULL_VALUE) {
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
            pos_temp.setI(-1);
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
        position cur(-1,-1);
        return cur;
    }
    void print()
    {
        for(int i=0;i<maxSize;i++)
        {
            cout<<i<<" -> ";
            if(table[i]!= NULL_VALUE)
            {
                SymbolInfo *temp = table[i];

                for (;temp!= NULL_VALUE;)
                {
                    cout<<"<"<<temp->getName().c_str()<<","<<temp->getType().c_str()<<"> ";
                    temp=temp->getNext();
                }
            }
            cout<<endl;
        }
        return;
    }

    position Delete(string  st)
    {
        position cur=lookUp(st);
        if(cur.getI()==-1)
        {
            return cur;
        }
        SymbolInfo* now,*prev;
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
        free(now);
        return  cur;



    }





};



void func()
{
    string line;
    ifstream myfile ("input.txt");
    SymbolTable st;
    bool first=true;

    if (myfile.is_open())
    {
        while ( getline (myfile,line) )
        {
            string temp1,temp2;
            istringstream iss(line);
            if(first)
            {
                int s;
                iss>>s;
                iss>>s;
                st.setSize(s);
                first=false;
            }
            for(;iss;)
            {
                iss>>temp1;
                if(temp1.compare("I")==0)
                {

                    string temp1,temp2;
                    iss>>(temp1)>>temp2;


                    SymbolInfo *si=new SymbolInfo(temp2,temp1);


                    position pos=(position)st.insert(si);
                    if(pos.getI()!=-1)
                    {
                        cout<<"<"<<temp1<<","<<temp2<<">"<<"Inserted at position "<<(pos).getI()<<"  "<<pos.getJ()<<endl;
                    }
                    else
                    {
                        cout<<temp1<<" Already exist"<<endl;
                    }
                    iss>>temp1;
                }
                else if(temp1.compare("P")==0)
                {

                    st.print();
                    iss>>temp1;
                }
                else if(temp1.compare("D")==0)
                {
                    iss>>temp1;

                    position pos=(position)st.Delete(temp1);
                    if(pos.getI()==-1)
                    {
                        cout<<temp1<<" Not Found"<<endl;
                    }
                    else
                    {
                        cout<<"Deleted from "<<(pos).getI()<<"  "<<pos.getJ()<<endl;
                    }
                    iss>>temp1;


                }
                else if(temp1.compare("L")==0)
                {
                     iss>>temp1;

                    position pos=(position)st.lookUp(temp1);
                    if(pos.getI()==-1)
                    {
                        cout<<temp1<<" Not Found"<<endl;
                    }
                    else
                    {
                    cout<<"<"<<temp1<<","<<pos.getType()<<" Found at "<<(pos).getI()<<"  "<<pos.getJ()<<endl;
                    iss>>temp1;
                    }

                }

            }





        }
        //st.print();
        myfile.close();
    }



}
int main()
{

    func();
   /* string s[8]={"asd","dsdef","qwe","dsdef","we","d78wrf","asq","zxcv"};

    SymbolTable st(5);

   for(int i=0;i<7;i=i+1)
   {
       string temp1,temp2;
       temp1=s[i];
       i++;
       temp2=s[i];
       SymbolInfo *si=new SymbolInfo(temp1,temp2);
       cout<<(st.insert(si)).getI()<<endl;


   }
    st.print();*/














    return 0;


}
