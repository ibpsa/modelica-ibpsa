#ifndef IBPSA_FILEWRITERStructure_c 
#define IBPSA_FILEWRITERStructure_c

#include "fileWriterStructure.h"


signed int fileWriterIsUnique(const char* fileName){
  int i;
  for(i = 0; i < FileWriterNames_n; i++){
    if (!strcmp(fileName, FileWriterNames[i])){
      return i;
    }
  }
  return -1;
}

void* allocateFileWriter(
    const char* instanceName,
    const char* fileName){

   if ( FileWriterNames_n == 0 ){
    /* Allocate memory for array of file names */
    FileWriterNames = malloc(sizeof(char*));
    if ( FileWriterNames == NULL )
      ModelicaError("Not enough memory in fileWriterStructure.c for allocating FileWriterNames.");
  }
  else{
    /* Check if the file name is unique */
    signed int index = fileWriterIsUnique(fileName);
    if (index>=0){
      ModelicaFormatError("FileWriter %s writes to file %s which is already used by another FileWriter.\nEach FileWriter must use a unique file name.",
      FileWriterNames[index], fileName);
      /* TODO:  print instance name instead of file name */
    }
    /* Reallocate memory for array of file names */
    FileWriterNames = realloc(FileWriterNames, (FileWriterNames_n+1) * sizeof(char*));
    if ( FileWriterNames == NULL )
      ModelicaError("Not enough memory in fileWriterStructure.c for reallocating FileWriterNames.");
  }
  /* Allocate memory for this file name */
  FileWriterNames[FileWriterNames_n] = malloc((strlen(fileName)+1) * sizeof(char));
  if ( FileWriterNames[FileWriterNames_n] == NULL )
    ModelicaError("Not enough memory in fileWriterStructure.c for allocating FileWriterNames[].");
  /* Copy the file name */
  strcpy(FileWriterNames[FileWriterNames_n], fileName);
  FileWriterNames_n++;

  FileWriter* ID;
  ID = (FileWriter*)malloc(sizeof(*ID));
  if ( ID == NULL )
    ModelicaFormatError("Not enough memory in fileWriterStructure.c for allocating ID of FileWriter %s.", instanceName);

  ID->fileWriterName = malloc((strlen(fileName)+1) * sizeof(char));
  if ( ID->fileWriterName == NULL )
    ModelicaFormatError("Not enough memory in fileWriterStructure.c for allocating ID->fileWriterName in FileWriter %s.", instanceName);
  strcpy(ID->fileWriterName, fileName);

  ID->instanceName = malloc((strlen(instanceName)+1) * sizeof(char));
  if ( ID->instanceName == NULL )
    ModelicaFormatError("Not enough memory in fileWriterStructure.c for allocating ID->instanceName in FileWriter %s.", instanceName);
  strcpy(ID->instanceName, instanceName);

  FILE *fp = fopen(fileName, "w");
  if (fp == NULL)
    ModelicaFormatError("In fileWriterStructure.c: Failed to create empty file %s during initialisation.", fileName);
  if (fclose(fp)==EOF)
    ModelicaFormatError("In fileWriterStructure.c: Returned an error when closing %s.", fileName);

  return (void*)ID;
}

#endif