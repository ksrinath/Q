#include<stdint.h>
#include<stdio.h>
#include<string.h>


FILE * createFile(char *fname)
{
	char filepath[50] = "/home/pragati/Desktop/CSV_LOAD/";
	
	strcat(filepath,fname);
	strcat(filepath,".bin");
	//printf("%s",filepath);
	
	FILE *file = fopen(filepath, "wb");
	return file;
	
}


FILE * convertAndWrite(const char **arr, char *type,int n, FILE *fname)
{
  if (strcmp(type,"int32_t") == 0)
	{
      char *ptr = NULL;
   		int32_t ret;
      if(fname == NULL) 
      {
        		printf("error creating file");
      }
    	
      int i;
      for(i = 0; i < n; i++)
      {
        ret = strtol(arr[i],&ptr, 10);
        //printf("The number(unsigned integer32) is %d\n", ret);   
        fwrite((const void*)&ret,sizeof(int32_t),1,fname);
      }
      return fname;
      
	}
	else if(strcmp(type,"int16_t") == 0)
	{
      char *ptr = NULL;
      int16_t ret;
      if(fname == NULL) 
      {
            printf("error creating file");
      }
    	
      int i;
      for(i = 0; i < n; i++)
      {
        ret = strtol(arr[i],&ptr, 10);
        //printf("The number(unsigned integer16) is %d\n", ret);   
        fwrite((const void*)&ret,sizeof(int16_t),1,fname);
      }
      return fname;
	}	
  else if(strcmp(type,"int8_t") == 0)
	{
      char *ptr = NULL;
      int8_t ret;
      if(fname == NULL) 
      {
            printf("error creating file");
      }
    	
      int i;
      for(i = 0; i < n; i++)
      {
        ret = strtol(arr[i],&ptr, 10);
        //printf("The number(unsigned integer8) is %d\n", ret);   
        fwrite((const void*)&ret,sizeof(int8_t),1,fname);
      }
      return fname;
	}	
  else if(strcmp(type,"int64_t") == 0)
	{
      char *ptr = NULL;
      int16_t ret;
      if(fname == NULL) 
      {
            printf("error creating file");
      }
    	
      int i;
      for(i = 0; i < n; i++)
      {
        ret = strtol(arr[i],&ptr, 10);
        //printf("The number(unsigned integer64) is %d\n", ret);   
        fwrite((const void*)&ret,sizeof(int64_t),1,fname);
      }
      return fname;
	}	
	
}

FILE * convertAndWriteString(int32_t *arr, char *type,int n, FILE *fname)
{
    if (strcmp(type,"int32_t") == 0)
    {
      if(fname == NULL) 
      {
        		printf("error creating file");
      }
    	
      int i;
      for(i = 0; i < n; i++)
      {
        
        //printf("The number(unsigned integer32) is %d\n", arr[i]);   
        fwrite((const void*)&arr[i],sizeof(int32_t),1,fname);
      }
      return fname;
    }
    
}



void close(FILE *fname)
{
	fclose(fname);
}
