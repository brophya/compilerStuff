#include <string.h>
#include<stdio.h>
#include<stdlib.h>
#define HASHSIZE 101

unsigned int baseVal = 268500992; 
unsigned int nextWord = 0; 


typedef struct Var{
    char* name; 
    char* type; 
    unsigned int memAdd; 
    struct Var* nextEntry;
} var_t;


static var_t * hashTable[HASHSIZE];
char* typeArray[2] = {"int", "char"};

unsigned int hash(char* varName){
    
    unsigned int hashVal;
    for (hashVal = 0; *varName != '\0'; *varName++ )
        hashVal = *varName + 31 * hashVal; 
    return hashVal % HASHSIZE;
    
}

var_t * lookUp(char* varName){
    
    var_t *np; 
    
    for (np = hashTable[hash(varName)]; np!= NULL; np = np->nextEntry)
        if(!strcmp(varName,np->name))
            return np; 
    return NULL;
}

var_t *install(char*name, char*type){
    
    var_t * np;
    unsigned int hashVal;     
    if((np = lookUp(name)) == NULL){
        np = (var_t*) malloc(sizeof(*np));
        if( np == NULL || (np->name = strdup(name))== NULL)
            return NULL; 
        np->memAdd = baseVal + nextWord;
        nextWord += 4;  
        hashVal = hash(name);
        np->nextEntry = hashTable[hashVal]; 
        hashTable[hashVal] = np; 
        
    }
    else
        free((void*) np->type);
        
    if((np->type = strdup(type)) == NULL)
        return NULL; 
    return np; 
}

unsigned int getAdd(char* varName){

    var_t* np; 
     for (np = hashTable[hash(varName)]; np!= NULL; np = np->nextEntry)
        if(!strcmp(varName,np->name))
            return np->memAdd;

}
