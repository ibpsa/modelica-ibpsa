// Author: Filip Jorissen
// License: See IBPSA library

#include <FileWriter.h>

// Creates an empty file
void createFile(const char* fileName){
  FILE *f = fopen(fileName, "w");
  fclose(f);
}

// Append a string to an existing file.
// Time is included as an input to ensure that
// the function is called during each time step.
double appendString(const char* fileName, const char* string, double time){
  FILE *f = fopen(fileName, "a");
  fputs(string, f);
  fclose(f);
  return 0;
}
