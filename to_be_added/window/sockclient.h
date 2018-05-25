#include<io.h>
#include<stdio.h>
#include<winsock2.h>
#include <assert.h>

#pragma comment (lib, "Ws2_32.lib")
#pragma comment (lib, "Mswsock.lib")
#pragma comment (lib, "AdvApi32.lib")
#pragma warning(disable:4996) 

char** str_split(char* a_str, char a_delim)
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
 
int swap(int as,double a[],  char* host, int port, double c[])
{
    WSADATA wsa;
    SOCKET s;
    struct sockaddr_in server;
    char message[2000], server_reply[2000];
    int recv_size;
    char** tokens;
    puts("start\n");    

    if (WSAStartup(MAKEWORD(2,2),&wsa) != 0)
    {
        printf("Failed. Error Code : %d",WSAGetLastError());
        return 1;
    }
     
 
    //Create socket
    if((s = socket(AF_INET , SOCK_STREAM , 0 )) == INVALID_SOCKET)
    {
        printf("Could not create socket : %d" , WSAGetLastError());
		return 1;
    }
     
    server.sin_addr.s_addr = inet_addr(host);
    server.sin_family = AF_INET;
    server.sin_port = htons( port );
	
    int i;

   /* for loop execution */
    for( i = 0; i < as; i = i + 1 ){
      char buffer[8];
      sprintf(buffer,"%f", *(a+i));

//      size_t len = strlen(buffer);
      strcat(buffer, ",");
//      buffer[len]=",";
//      puts(buffer);	
//      buffer[len + 1] = '\0';

      strcat(message, buffer);
    }	
//    puts(message);	

    //Connect to remote server
    if (connect(s , (struct sockaddr *)&server , sizeof(server)) < 0)
    {
        puts("connect error");
        return 1;
    }
     
//    puts("Connected");
         



         
        //Send some data
    if( send(s , message , strlen(message) , 0) < 0)
    {
        puts("Send failed");
        return 1;
    }
//    puts("Data Send\n");
         
        //Receive a reply from the server
    if((recv_size = recv(s , server_reply , 2000 , 0)) == SOCKET_ERROR)
    {
        puts("recv failed");
    }
     

//    puts("Server reply :");
//    puts(server_reply);
    
    tokens = str_split(server_reply, ',');
//    puts(*tokens);
    i=0;
    for( i = 0; i <as; i = i + 1 ){
         *(c+i) = atof(*(tokens+i));
//         *(c+i) = *(a+i);
//		     puts(*(tokens+i));
    }	

    closesocket(s);
    WSACleanup();
    printf("Result : %d" , *c);
    return 1;
}