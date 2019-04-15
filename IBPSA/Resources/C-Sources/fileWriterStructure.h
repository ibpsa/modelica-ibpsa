/*
 * A structure to store the data needed for the CSV writer.
 */

#ifndef IBPSA_FILEWRITERStructure_h /* Not needed since it is only a typedef; added for safety */
#define IBPSA_FILEWRITERStructure_h

static char** FileWriterNames; /* Array with pointers to all file names */
static unsigned int FileWriterNames_n = 0;     /* Number of files */

typedef struct FileWriter {
  /* Common for CSV and JSON writer */
  char* fileWriterName; /* The result data file of this file writer */
  char* instanceName; /* The name of the Modelica model instance that corresponds to this file writer. For error reporting purposes. */

  /* Parameters for CSV writer only */
  int isCombiTimeTable; /* Indicates whether combiTimeTable header should be prepended before destruction */
  int numRows; /* Number of lines that have been written to file */
  int numColumns; /* Number of rows that the file writer is storing */

  /* Parameters for JSON writer only */	
  int dumpAtDestruction; /* Indicates whether json data should be dumped before destruction */
  char **varKeys;
  int numKeys;
  double *varVals;

} FileWriter;

void writeLine(void *ptrFileWriter, const char* line, const int isMetaData); /* This function writes a line to the FileWriter object file and counts the number of lines that are written. */

void* allocateFileWriter(const char* instanceName, const char* fileName); /* This function verifies whether a file writer with the same path does not yet exist */

#endif
