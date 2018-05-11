// Author: Filip Jorissen
// License: See IBPSA library

#include <stdio.h>


// Creates an empty file
void createFile(const char* fileName){
  FILE *f = fopen(fileName, "w");
  fclose(f);
}
