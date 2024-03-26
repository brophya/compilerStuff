#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
char bufferLine[31]; 
char varAdd[11]; 

int main(){

	FILE *fpUnoptomized;
        FILE *fpOptomized;
        int lastLine, i, j;

        if((fpUnoptomized = fopen("codeToOptimize", "r")) == NULL)
           {printf("source file opening error :(\n"); return -1;}

	if((fpOptomized = fopen("optimizedCode", "w")) == NULL)
           {printf("destination file opening error :(\n"); return -1;}

	while(fgets(bufferLine, 30, fpUnoptomized) != NULL){
            if( (bufferLine[0] == 's') && (bufferLine[1] == 'w') ){
                 if(isspace(bufferLine[7])) j = 1; else j = 0;  
                 for(i = 0; i < 11; i++) 
                      varAdd[i] = bufferLine[i+7+j]; 
             printf("%s", varAdd);
	    }

        }


}
