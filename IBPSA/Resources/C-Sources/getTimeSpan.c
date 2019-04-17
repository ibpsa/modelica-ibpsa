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
int getTimeSpan(const char * filename, const char * tabNam, double* timeSpan) {
	double firstTimeStamp, lastTimeStamp, interval;
	int rowCount, colonCount;
	int rowIndex=0;
	int tempInd=0;
	char colonCountString[5];
	char *lastColonIndicator;
	char *line = NULL;
	size_t len=0;

	FILE *fp;

	/* create format string: "%*s tab1(rowCount, colonCount)" */
	char *tempString = concat("%*s ", tabNam);
	char *formatString = concat(tempString, "(%d,%d)");
	free(tempString);

	fp = fopen(filename, "r");

	/* find rowCount and colonCount */
	while (1) {
		rowIndex++;
		if (fscanf(fp, formatString, &rowCount, &colonCount) == 2) {
			break;
		}
	}
	free(formatString);

	getline(&line, &len, fp); /* finish the line */
	getline(&line, &len, fp); /* keep reading next line */
	rowIndex++;

   /* find the end of file head */
	sprintf(colonCountString, "%d", colonCount);
	lastColonIndicator = concat("#C",colonCountString);
	while (1) {
		getline(&line, &len, fp);
		rowIndex++;
		if (strstr(line, lastColonIndicator)) {
			break;
		}
	}
	free(lastColonIndicator);

	/* find first time stamp */
	fscanf(fp, "%lf", &firstTimeStamp);
	getline(&line, &len, fp); /* finish the line */
	rowIndex++;

	/* scan to file end, to find the last time stamp */
	tempInd = rowIndex;
	while (rowIndex < (rowCount+tempInd-2)) {
		getline(&line, &len, fp);
		rowIndex++;
	}
	fscanf(fp, "%lf", &lastTimeStamp);
	free(line);
	fclose(fp);

	/* find average time inteval */
	interval = (lastTimeStamp - firstTimeStamp) / (rowCount - 1);

	timeSpan[0] = firstTimeStamp;
	timeSpan[1] = lastTimeStamp + interval;

	return(0);
}
