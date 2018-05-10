#include <stdio.h>

// Creates an empty file
void createFile(const char* fileName);

// Append a string to an existing file.
// Time is included as an input to ensure that
// the function is called during each time step.
double appendString(const char* fileName, const char* string, double time);
