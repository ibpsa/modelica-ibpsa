/* Function that frees the memory for the FileWriter.
 *
 * Michael Wetter, LBNL                     2018-05-12
 */
#include "fileWriterStructure.h"
#include <stdlib.h>
#include <stdio.h>


void jsonWriterFree(void* ptrFileWriter){
  FileWriter *ID = (FileWriter*)ptrFileWriter;

  /* If this FileWriter writes output at terminal(), dump data upon destruction. */
  if (ID->dumpAtDestruction){
    writeJson(ptrFileWriter,  ID->varVals, ID->numKeys);
  }

  free(ID->varVals);
  int i;
  for (i = 0; i < ID->numKeys; ++i)
  {
    free(ID->varKeys[i]);
  }
  free(ID->varKeys);

  if ( FileWriterNames_n > 0 ){
    FileWriterNames_n--;
    free(FileWriterNames[FileWriterNames_n]);
    if ( FileWriterNames_n == 0 ){
      free(FileWriterNames);
    }
  }
  free(ID->fileWriterName);
  free(ID->instanceName);
  free(ID);
  return;
}
