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
 *  concatenate two string .
 *
 *  s1: string one
 *  s2: string two
 *
 *  returns: concatenate string (s1 + s2)
 */
char *concat(const char *s1, const char *s2) {
	const size_t len1 = strlen(s1);
	const size_t len2 = strlen(s2);
	char *result = malloc(len1 + len2 + 1);
	strcpy(result, s1);
	strcat(result, s2);
	return result;
}

/*
 * Funciton: getTimeSpan
 * ---------------------
 * get start and end time of weather data
 *
 * filename: weather data file path
 * tabNam: name of table on weather file
 * startTime: start time
 * endTime: end time
 */
void getTimeSpan(const char * filename, const char * tabNam, double * startTime, double * endTime) {
	double firstTimeStamp, lastTimeStamp, interval;
	int loopFlag = 0;
	char temp[500];
	int rowCount, colonCount, rowIndex=0;
	char colonCountString[5];
	int tempInd=0;
	char *lastColonIndicator;

	// format string: "%*s tab1(rowCount, colonCount)"
	char *tempString = concat("%*s ", tabNam);
	char *formatString = concat(tempString, "(%d,%d)");

	FILE *fp;
	fp = fopen(filename, "r");

	// find rowCount and colonCount
	while (loopFlag == 0) {
		if (fscanf(fp, formatString, &rowCount, &colonCount) == 2) {
			loopFlag = 1;
		}
		rowIndex++;
	}
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

	// read to the file end to find the last time stamp
	tempInd = rowIndex;
	while (rowIndex < (rowCount+tempInd-2)) {
		fgets(temp, 500, fp);
		rowIndex++;
	}
	fscanf(fp, "%lf", &lastTimeStamp);
	fclose(fp);

	// find average time inteval
	interval = (lastTimeStamp - firstTimeStamp) / (rowCount - 1);
	*startTime = firstTimeStamp;
	*endTime = lastTimeStamp + interval;
}
