void writeLine(FILE * fOut, const char* line, const char* fileName){
	if (fputs(line, fOut)==EOF){
    	ModelicaFormatError("In writeJson.c: Returned an error when writing to %s.", fileName);
	}
}


void writeJson(const char* fileName, const char** varNames, const int numNames,  const double* varVals, const int numVals){
	if (numNames!=numVals){
		ModelicaFormatError("In writeJson.c: The supplied vector of names and values do not have equal lengths: %d and %d", numNames, numVals);
	}

	FILE *fOut = fopen(fileName, "w");
	
	writeLine(fOut, "{\n", fileName);

	int i;
	for (i = 0; i < numNames; ++i){
		if (strlen(varNames[i])>100){
			ModelicaFormatError("The variable name \"%s\" is too long. It must be shorter than 100 characters.", varNames[i]);
		}
		char buffer[200];
		sprintf(buffer, "\"%s\" : %.10e", varNames[i], varVals[i]);
		writeLine(fOut, buffer, fileName);
		if (i==numNames-1){
			writeLine(fOut,"\n",fileName);
		}else{
			writeLine(fOut,",\n",fileName);
		}
	}
	writeLine(fOut, "}\n", fileName);

	fclose(fOut);
}