// source: djb2 from http://www.cse.yorku.ca/~oz/hash.html

char* hash(char *str)
{
    unsigned long hash = 5381;
    int c;

    while (c = *str++)
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
	
	char* result= malloc(21*sizeof(char)); // 20 chars for representing number of up to 1.8 * 10^19 and 1 char for \0
	sprintf(result, "%lu%", hash);

    return result;
}