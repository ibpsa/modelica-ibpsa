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
 * Funciton: getTimeSpan
 * ---------------------
 * Get start and end time of weather data.
 *
 * filename: weather data file path
 * tabNam: name of table on weather file
 * timeSpan: vector [start time, end time]
 */
void getTimeSpan(const char * filename, const char * tabNam, double* timeSpan) {
	double firstTimeStamp, lastTimeStamp, interval;
	char temp[500];
	int rowCount, colonCount, rowIndex=0;
	char colonCountString[5];
	int tempInd=0;
	char *lastColonIndicator;

	// create format string: "%*s tab1(rowCount, colonCount)"
	char *tempString = concat("%*s ", tabNam);
	char *formatString = concat(tempString, "(%d,%d)");
	free(tempString);

	FILE *fp;
	fp = fopen(filename, "r");

	// find rowCount and colonCount
	while (1) {
		rowIndex++;
		if (fscanf(fp, formatString, &rowCount, &colonCount) == 2) {
			break;
		}
	}
	free(formatString);

	fgets(temp, 500, fp); // finish the line
	fgets(temp, 500, fp); // keep reading next line
	rowIndex++;

  // find the end of file head
	sprintf(colonCountString, "%d", colonCount);
	lastColonIndicator = concat("#C",colonCountString);
	while (1) {
		fgets(temp, 500, fp);
		printf("line: %s\n", temp);
		rowIndex++;
		if (strstr(temp, lastColonIndicator)) {
			break;
		}
	}

	// find first time stamp
	fscanf(fp, "%lf", &firstTimeStamp);
	fgets(temp, 500, fp); // finish the line
	rowIndex++;

	// scan to file end, to find the last time stamp
	tempInd = rowIndex;
	while (rowIndex < (rowCount+tempInd-2)) {
		fgets(temp, 500, fp);
		rowIndex++;
	}
	fscanf(fp, "%lf", &lastTimeStamp);
	fclose(fp);

	// find average time inteval
	interval = (lastTimeStamp - firstTimeStamp) / (rowCount - 1);

	timeSpan[0] = firstTimeStamp;
	timeSpan[1] = lastTimeStamp + interval;
}
