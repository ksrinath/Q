#include<stdint.h>
#include<stdio.h>
#include<string.h>


FILE * createFile(char *fname)
{
	int i;
	/*for (i = 0; i < strlen(fname); i++ ) { 
    		printf("%c",fname[i]);
  	}*/
	
	char filepath[50] = "/home/pragati/Desktop/CSV_LOAD/";
	
	strcat(filepath,fname);
	strcat(filepath,".bin");
	//printf("%s",filepath);
	
	FILE *file = fopen(filepath, "wb");
	return file;
	
}

FILE * writeFile(char *arr, char *type,FILE *fname)
{
	/*int i;
 	for (i = 0; i < 4; i++ ) { 
    		printf("%c",T[i]);
  	}
	printf("\n");
	for (i = 0; i < 7; i++ ) { 
    		printf("%c",str[i]);
  	}*/

	if (strcmp(type,"int32_t") == 0)
	{
		char *ptr = NULL;
   		int32_t ret;

	
		if(fname == NULL) {
        		printf("error creating file");
    		}
    	
   		ret = strtol(arr,&ptr, 10);
  		printf("The number(unsigned integer32) is %d\n", ret);   
		fwrite((const void*)&ret,sizeof(int32_t),1,fname);
		return fname;

	}
	else if(strcmp(type,"int16_t") == 0)
	{
		char *ptr = NULL;
   		int16_t ret;

	
		if(fname == NULL) {
        		printf("error creating file");
    		}
    	
   		ret = strtol(arr,&ptr, 10);
  		printf("The number(unsigned integer16) is %d\n", ret);   
		fwrite((const void*)&ret,sizeof(int16_t),1,fname);
		return fname;
	}	
	
}
void close(FILE *fname)
{
	fclose(fname);
}
