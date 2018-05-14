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
  if(fseek(fr, 0, SEEK_END)!=0)
  	ModelicaFormatError("The file %s could not be read.", fileName);
  long fsize = ftell(fr);
  if (fsize==-1)
  	ModelicaFormatError("The file %s could not be read.", fileName);
  if(fseek(fr, 0, SEEK_SET)!=0)
  	ModelicaFormatError("The file %s could not be read.", fileName);

  char *origString = malloc(fsize + 1);
  if ( origString == NULL ){
    // not enough memory is available: file too large
    ModelicaError("Not enough memory in fileWriterInit.c for prepending string.");
  } 
  if (fread(origString, fsize, 1, fr)==0)
  	ModelicaFormatError("The file %s could not be read.", fileName);
  	
  fclose(fr);
  origString[fsize] = '\0';

  // write new contents
  FILE *fw = fopen(fileName, "w");
  // prepended string
  if (fputs(string, fw)==EOF)
    ModelicaFormatError("The file %s could not be written.", fileName);
  // original data
  if (fputs(origString, fw)==EOF)
    ModelicaFormatError("The file %s could not be written.", fileName);  

  fclose(fw);

  free(origString);
}

#endif
