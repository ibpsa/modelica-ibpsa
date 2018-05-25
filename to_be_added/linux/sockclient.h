#include<stdio.h> //printf
#include<string.h>    //strlen
#include<sys/socket.h>    //socket
#include<arpa/inet.h> //inet_addr
#include <stdlib.h>
#include <assert.h>


char** str_split(char* a_str, const char a_delim)
{
    char** result    = 0;
    size_t count     = 0;
    char* tmp        = a_str;
    char* last_comma = 0;
    char delim[2];
    delim[0] = a_delim;
    delim[1] = 0;

    /* Count how many elements will be extracted. */
    while (*tmp)
    {
        if (a_delim == *tmp)
        {
            count++;
            last_comma = tmp;
        }
        tmp++;
    }

    /* Add space for trailing token. */
    count += last_comma < (a_str + strlen(a_str) - 1);

    /* Add space for terminating null string so caller
       knows where the list of returned strings ends. */
    count++;

    result = malloc(sizeof(char*) * count);

    if (result)
    {
        size_t idx  = 0;
        char* token = strtok(a_str, delim);

        while (token)
        {
            assert(idx < count);
            *(result + idx++) = strdup(token);
            token = strtok(0, delim);
        }
        assert(idx == count - 1);
        *(result + idx) = 0;
    }

    return result;
}
 
int swap(int as,double a[],  const char** host, const int port, double c[])
{
    int sock;
    struct sockaddr_in server;
    char message[1000], server_reply[2000];
    char** tokens;
   
    //Create socket
    sock = socket(AF_INET , SOCK_STREAM , 0);
    if (sock == -1)
    {
        printf("Could not create socket");
    }
    puts("Socket created");
     
    server.sin_addr.s_addr = inet_addr(host);
    server.sin_family = AF_INET;
    server.sin_port = htons(port);
 
    //Connect to remote server
    if (connect(sock , (struct sockaddr *)&server , sizeof(server)) < 0)
    {
        perror("connect failed. Error");
        return 1;
    }
     
    puts("Connected\n");
         
    int i;

   /* for loop execution */
    for( i = 0; i < as; i = i + 1 ){
      char buffer[4];
      sprintf(buffer,"%f", *(a+i));
      size_t len = strlen(buffer);
      buffer[len]=',';
      buffer[len + 1] = '\0';
      strcat(message, buffer);
    }	

    puts(message);
         
        //Send some data
    if( send(sock , message , strlen(message) , 0) < 0)
    {
            puts("Send failed");
            return 1;
    }
         
        //Receive a reply from the server
    if( recv(sock , server_reply , 2000 , 0) < 0)
    {
            puts("recv failed");
            return 2;
    }
         
    puts("Server reply :");
    puts(server_reply);
    
    tokens = str_split(server_reply, ',');
    puts(*tokens+as-2);
    for( i = 0; i <as; i = i + 1 ){
         *(c+i) = atof(*(tokens+i));
    }	
    
    close(sock);
    return 1;
}