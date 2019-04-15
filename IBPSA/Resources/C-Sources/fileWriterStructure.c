#ifndef IBPSA_FILEWRITERStructure_c 
#define IBPSA_FILEWRITERStructure_c

#include "fileWriterStructure.h"

void* allocateFileWriter(
    const char* instanceName,
    const char* fileName){

   if ( FileWriterNames_n == 0 ){
    /* Allocate memory for array of file names */
    FileWriterNames = malloc(sizeof(char*));
    if ( FileWriterNames == NULL )
      ModelicaError("Not enough memory in jsonWriterInit.c for allocating FileWriterNames.");
  }
  else{
    /* Check if the file name is unique */
    if (! fileWriterIsUnique(fileName)){
      ModelicaFormatError("FileWriter %s writes to file %s which is already used by another FileWriter.\nEach FileWriter must use a unique file name.",
      FileWriterNames[0], fileName);
    }
    /* Reallocate memory for array of file names */
    FileWriterNames = realloc(FileWriterNames, (FileWriterNames_n+1) * sizeof(char*));
    if ( FileWriterNames == NULL )
      ModelicaError("Not enough memory in jsonWriterInit.c for reallocating FileWriterNames.");
  }
  /* Allocate memory for this file name */
  FileWriterNames[FileWriterNames_n] = malloc((strlen(fileName)+1) * sizeof(char));
  if ( FileWriterNames[FileWriterNames_n] == NULL )
    ModelicaError("Not enough memory in jsonWriterInit.c for allocating FileWriterNames[].");
  /* Copy the file name */
  strcpy(FileWriterNames[FileWriterNames_n], fileName);
  FileWriterNames_n++;

  FileWriter* ID;
  ID = (FileWriter*)malloc(sizeof(*ID));
  if ( ID == NULL )
    ModelicaFormatError("Not enough memory in jsonWriterInit.c for allocating ID of FileWriter %s.", instanceName);

  ID->fileWriterName = malloc((strlen(fileName)+1) * sizeof(char));
  if ( ID->fileWriterName == NULL )
    ModelicaFormatError("Not enough memory in jsonWriterInit.c for allocating ID->fileWriterName in FileWriter %s.", instanceName);
  strcpy(ID->fileWriterName, fileName);

  ID->instanceName = malloc((strlen(instanceName)+1) * sizeof(char));
  if ( ID->instanceName == NULL )
    ModelicaFormatError("Not enough memory in jsonWriterInit.c for allocating ID->instanceName in FileWriter %s.", instanceName);
  strcpy(ID->instanceName, instanceName);

  return (void*)ID;
}

#endif