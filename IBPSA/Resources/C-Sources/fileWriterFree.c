/* Function that frees the memory for the FileWriter.
 *
 * Michael Wetter, LBNL                     2018-05-12
 */
#include "fileWriterStructure.h"
#include <stdlib.h>

void fileWriterFree(void* ptrFileWriter){
  FileWriter *ID = (FileWriter*)ptrFileWriter;
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
