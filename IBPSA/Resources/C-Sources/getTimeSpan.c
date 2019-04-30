/*
 * getTimeSpan.c
 *
 *  Created on: Apr 16, 2019
 *      Author: jianjun
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include "getTimeSpan.h"

/*
 * Function: concat
 * -----------------
 *  Concatenate two strings. This function calls malloc and hence
 *  the caller must call free when the returned string is no longer used.
 *
 *  s1: string one
 *  s2: string two
 *
 *  returns: concatenate strings (s1 + s2)
 */
char *concat(const char *s1, const char *s2) {
  const size_t len1 = strlen(s1);
  const size_t len2 = strlen(s2);
  char *result = malloc(len1 + len2 + 1);
  if (result == NULL){
    ModelicaError("Failed to allocate memory in getTimeSpan.c");
  }
  strcpy(result, s1);
  strcat(result, s2);
  return result;
}

/*
 * Function: searchLine
 * --------------------
 *  Output an entire line in file. This function calls malloc and hence
 *  the caller must call free when the return string is no longer used.
 *
 *  length: maximum length of each read done by fgets()
 *  fp: pointer to the FILE object
 *
 *  returns: entire line string
 */
char *searchLine(int length, FILE *fp) {
  int loop = 0;
  char *tempLine;
  char *line;
  tempLine = (char *)malloc(length*sizeof(char));
  if (tempLine == NULL) {
    ModelicaError("Failed to allocate memory in getTimeSpan.c");
  }
  line = (char *)malloc(length*sizeof(char));
  if (line == NULL) {
    ModelicaError("Failed to allocate memory in getTimeSpan.c");
  }
  while (fgets(tempLine, length, fp)) {
    loop++;
    /* reallocate memory for line, to ensure enough space to concatenate new reading */
    line = (char *)realloc(line, loop*length*sizeof(char));
    if (line == NULL) {
      ModelicaError("Failed to allocate memory in getTimeSpan.c");
    }
    /* concatenate new reading to old reading */
    line = concat(line, tempLine);
    if (strstr(tempLine, "\n")) {
      break;
    }
  }
  free(tempLine);

  return line;
}

/*
 * Function: getTimeSpan
 * ---------------------
 * Get start and end time of weather data.
 *
 * fileName: weather data file path
 * tabName: name of table on weather file
 * timeSpan: vector [start time, end time]
 */
int getTimeSpan(const char * fileName, const char * tabName, double* timeSpan) {
  double firstTimeStamp, lastTimeStamp, interval;
  int rowCount, columnCount;
  int rowIndex = 0;
  int tempInd  = 0;
  int length   = 20; /* maximum length of each read done by fgets() */
  char *line;
  int retVal;

  FILE *fp;

  /* create format string: "%*s tab1(rowCount, columnCount)" */
  char *tempString = concat("%*s ", tabName);
  char *formatString = concat(tempString, "(%d,%d)");
  free(tempString);

  fp = fopen(fileName, "r");
  if (fp == NULL){
    ModelicaFormatError("Failed to open file %s", fileName);
  }

  /* find rowCount and columnCount */
  while (1) {
    rowIndex++;
    if (fscanf(fp, formatString, &rowCount, &columnCount) == 2) {
      line = searchLine(length, fp); /* finish reading current line */
      free(line); /* free allocated memory */
      break;
    }
  }
  free(formatString);

  line = searchLine(length, fp); /* read next line */
  rowIndex++;

   /* find the end of file head */
  while(strstr(line, "#")) {
    free(line); /* free allocated memory */
    line = searchLine(length, fp);
    rowIndex++;
  }

  /* find first time stamp */
  retVal = sscanf(line, "%lf", &firstTimeStamp);
  free(line); /* free allocated memory */
  if (retVal == EOF){
    ModelicaFormatError("Received unexpected EOF in getTimeSpan.c when searching for first time stamp in %s.",
    fileName);
  }

  /* scan to file end, to find the last time stamp */
  tempInd = rowIndex;
  while (rowIndex < (rowCount+tempInd-2)) {
    fscanf(fp, "%*[^\n]\n", NULL);
    rowIndex++;
  }

  retVal = fscanf(fp, "%lf", &lastTimeStamp);

  if (retVal == EOF){
    ModelicaFormatError("Received unexpected EOF in getTimeSpan.c when searching last time stamp in %s.",
    fileName);
  }
  fclose(fp);

  /* find average time interval */
  if (rowCount < 2){
    ModelicaFormatError("Expected rowCount larger than 2 when reading %s.", fileName);
  }
  interval = (lastTimeStamp - firstTimeStamp) / (rowCount - 1);

  timeSpan[0] = firstTimeStamp;
  timeSpan[1] = lastTimeStamp + interval;

  return(0);
}
