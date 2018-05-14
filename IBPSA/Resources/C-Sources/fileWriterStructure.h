/*
 * A structure to store the data needed for the CSV writer.
 */

#ifndef IBPSA_FILEWRITERStructure_h /* Not needed since it is only a typedef; added for safety */
#define IBPSA_FILEWRITERStructure_h

static const char** FileWriterNames; /* Array with pointers to all file names */
static unsigned int FileWriterNames_n = 0;     /* Number of files */

void* prependString(const char* fileName, const char* string){
  // read original file contents
  FILE *fr = fopen(fileName, "r");
  fseek(fr, 0, SEEK_END);
  long fsize = ftell(fr);
  fseek(fr, 0, SEEK_SET);
  char *origString = malloc(fsize + 1);
  if ( origString == NULL ){
    // not enough memory is available: file too large
    ModelicaError("Not enough memory in fileWriterInit.c for prepending string.");
  } 
  fread(origString, fsize, 1, fr);
  fclose(fr);
  origString[fsize] = '\0';

  // write new contents
  FILE *fw = fopen(fileName, "w");
  // prepended string
  fputs(string, fw);
  // original data
  fputs(origString, fw);
  fclose(fw);

  free(origString);
}

#endif
