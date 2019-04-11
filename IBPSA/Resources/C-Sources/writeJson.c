#include <stdio.h>

void writeJsonLine(FILE * fOut, const char* line, const char* fileName){
	if (fputs(line, fOut)==EOF){
    	ModelicaFormatError("In writeJson.c: Returned an error when writing to %s.", fileName);
	}
}


void writeJson(const char* fileName, const char** varNames, const int numNames,  const double* varVals, const int numVals){
	if (numNames!=numVals){
		ModelicaFormatError("In writeJson.c: The supplied vector of names and values do not have equal lengths: %d and %d", numNames, numVals);
	}

	FILE *fOut = fopen(fileName, "w");
	if (fOut == NULL)
		ModelicaFormatError("In writeJson.c: Failed open file %s.", fileName);	
	
	writeJsonLine(fOut, "{\n", fileName);

	int i;
	for (i = 0; i < numNames; ++i){
		if (fprintf(fOut, "  \"%s\" : %.10e", varNames[i], varVals[i])<0){
			ModelicaFormatError("In writeJson.c: Returned an error when writing to %s.", fileName);
		}
		if (i==numNames-1){
			writeJsonLine(fOut,"\n",fileName);
		}else{
			writeJsonLine(fOut,",\n",fileName);
		}
	}
	writeJsonLine(fOut, "}\n", fileName);

	if (fclose(fOut)==EOF)
		ModelicaFormatError("In writeJson.c: Returned an error when closing %s.", fileName);
}
