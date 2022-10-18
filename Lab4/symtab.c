#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "symtab.h"

list_t* head = NULL;

void insert(char* name, int type)
{
    if(search(name)==NULL)
    {
        list_t *temp = (list_t*) malloc(sizeof(list_t));

        strcpy(temp->st_name, name);
        temp->st_type = type;

        printf("inserting %s with type %d in symbol table\n", name, type);

        temp->next = head;
        head = temp;
    }
    else
    {
        printf("Variable %s has been declared more than once\n", name);
        yyerror();
    }
}

list_t* search(char *name)
{
    list_t* current = head;

    while(current!=NULL)
    {
        if(strcmp(name, current->st_name)!=0)
        {
            current = current->next;
        }
        else
            break;
    }
    return current;
}

int id_check(char *name)
{
    list_t* id = search(name);

    if (id==NULL)
    {
        printf("%s is not declared\n", name);
        yyerror();
    }

    return(id->st_type);
}

int typecheck(int type1, int type2)
{
    if(type1==INT_TYPE && type2==INT_TYPE)
        return INT_TYPE;
    else if (type1==REAL_TYPE && type2==REAL_TYPE)
        return REAL_TYPE;
    else if (type1==CHAR_TYPE && type2==CHAR_TYPE)
        return CHAR_TYPE;
    else
    {
        printf("%d and %d types are not compitable\n",type1, type2);
        yyerror();
    }

}