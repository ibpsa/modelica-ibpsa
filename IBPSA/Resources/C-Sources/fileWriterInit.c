/* Function that ensure that each file CSV writer to a unique file.
 *
 * Michael Wetter, LBNL                     2018-05-12
 */
#include "FileWriterStructure.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


int fileWriterIsUnique(const char* fileName){
  int i;
  int isUnique = 1;
  for(i = 0; i < FileWriterNames_n; i++){
    if (!strcmp(fileName, FileWriterNames[i])){
      isUnique = 0;
      break;
    }
  }
  return isUnique;
}

void* fileWriterInit(
  const char* instanceName,
  const char* fileName){
  FILE *f = fopen(fileName, "w");
  fclose(f);

  if ( FileWriterNames_n == 0 ){
    // Allocate memory for array of file names
    FileWriterNames = malloc(sizeof(char*));
    if ( FileWriterNames == NULL )
      ModelicaError("Not enough memory in fileWriterInit.c for allocating FileWriterNames.");
  }
  else{
    // Check if the file name is unique
    if (! fileWriterIsUnique(fileName)){
      ModelicaFormatError("CSV writer %s writes to file %s which is already used by another CSV writer.\nEach CSV writer must use a unique file name.",
      instanceName, fileName);
    }
    // Reallocate memory for array of file names
    FileWriterNames = realloc(FileWriterNames, (FileWriterNames_n+1) * sizeof(char*));
    if ( FileWriterNames == NULL )
      ModelicaError("Not enough memory in fileWriterInit.c for reallocating FileWriterNames.");
  }
  // Allocate memory for this file name
  FileWriterNames[FileWriterNames_n] = malloc((strlen(fileName)+1) * sizeof(char));
  if ( FileWriterNames[FileWriterNames_n] == NULL )
    ModelicaError("Not enough memory in fileWriterInit.c for allocating FileWriterNames[].");
  // Copy the file name
  strcpy(FileWriterNames[FileWriterNames_n], fileName);
  FileWriterNames_n++;

  return (void*) fileName;
}
