/* Function that frees the memory for the CSV writer.
 *
 * Michael Wetter, LBNL                     2018-05-12
 */
#include "FileWriterStructure.h"
#include <stdlib.h>

void fileWriterFree(void* ptrFileWriter){
  if ( FileWriterNames_n > 0 ){
    FileWriterNames_n--;
    free(FileWriterNames[FileWriterNames_n]);
    if ( FileWriterNames_n == 0 ){
      free(FileWriterNames);
    }
  }
  return;
}
