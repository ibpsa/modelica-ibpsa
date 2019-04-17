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

char *concat(const char *s1, const char *s2) {
	const size_t len1 = strlen(s1);
	const size_t len2 = strlen(s2);
	char *result = malloc(len1 + len2 + 1);
	strcpy(result, s1);
	strcat(result, s2);
	return result;
}

/*
 * Function: file_exist
 * -----------------
 *  Test if file is in file system (with no dependency to unistd.h (access()): not available on Windows).
 *
 *  filename: path to file
 *
 *  returns: TRUE if exists
 */
int file_exist (const char *filename)
{
  struct stat buffer;
  return (stat(filename, &buffer) == 0);
}


void getTimeSpan(const char * filename, const char * tabNam, double * startTime, double * endTime) {
//int getTimeSpan(const char * filename, const char * tabNam) {
	double firstTimeStamp, lastTimeStamp, interval;
	int loopFlag = 0;
	char temp[500];
	int rowCount, colonCount, rowIndex=0;
	char *colonCountString;

	int tempInd=0;

	int test=765;

	double startTime;
	double endTime;

	// format string: "tab1(rowCount, colonCount)"
	char *tempString = concat("%*s ", tabNam);
	char *formatString = concat(tempString, "(%d,%d)");

	FILE *fp;
	if (file_exist(filename))
	{
		fp = fopen(filename, "r");
	    if (!(fp))
	    {
	      fprintf(stderr, "Cannot open file: %s\n", filename);
	    }
	  } else {
	    fprintf(stderr, "No such file: %s\n", filename);
	}

	while (loopFlag == 0) {
		if (fscanf(fp, formatString, &rowCount, &colonCount) == 2) {
			loopFlag = 1;
		}
		rowIndex++;
		printf("current row: %d\n", rowIndex);
	}
	fgets(temp, 500, fp); // finish the line
	fgets(temp, 500, fp); // keep reading next line
	rowIndex++;


	sprintf(colonCountString, "%d", colonCount);
	char *lastColonIndicator = concat("#C",colonCountString);
	while (1) {
		fgets(temp, 500, fp);
		printf("line: %s\n", temp);
		rowIndex++;
		if (strstr(temp, lastColonIndicator)) {
			break;
		}
	}

	tempInd = rowIndex;
	while (rowIndex < (rowCount+tempInd-1)) {
		fgets(temp, 500, fp);
		rowIndex++;
	}
	fscanf(fp, "%lf", &lastTimeStamp);

	interval = (lastTimeStamp - firstTimeStamp) / (rowCount - 1);

	*startTime = firstTimeStamp;
	*endTime = lastTimeStamp + interval;

}
