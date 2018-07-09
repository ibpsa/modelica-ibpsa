/* Function that exchange data with an external object via socket connection.
 *
 * Sen Huang, PNNL                     2018-07-09
 */
 
#include<stdio.h> 
#include<string.h> 
#include <stdlib.h>
#include <assert.h>

/* Function to parse message . */
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

/* Linux version of the socket client function. */
#ifdef __linux__ 
#include<sys/socket.h>    
#include<arpa/inet.h> 
int linuxSocket(int as,double a[],  const char** host, const int port, double c[])
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
    strcpy(message, ""); 
    for( i = 0; i < as; i = i + 1 ){
      char buf[8];
      strcpy(buf, "");
      sprintf(buf,"%1f", a[i]);
//      strcat(buf, ",");
      strcat(message, buf);
      strcat(message, ",");	  
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

/* Window version of the socket client function. */
#elif _WIN32
#include<winsock2.h>
#include<io.h>
#pragma comment (lib, "Ws2_32.lib")
#pragma comment (lib, "Mswsock.lib")
#pragma comment (lib, "AdvApi32.lib")
#pragma warning(disable:4996) 
#pragma comment (lib, "Ws2_32.lib")
#pragma comment (lib, "Mswsock.lib")
#pragma comment (lib, "AdvApi32.lib")
#pragma warning(disable:4996) 
 
int winSocket(int as, double a[],  char* host, int port, double c[])
{
    WSADATA wsa;
    SOCKET s;
    struct sockaddr_in server;
    char server_reply[2000];
    int recv_size;
    char** tokens;
//    puts("start\n");    

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
    char message[2000];
    char buf[8];

//    puts(message);	

    //Connect to remote server
    if (connect(s , (struct sockaddr *)&server , sizeof(server)) < 0)
    {
        puts("connect error");
        return 1;
    }
    strcpy(message, ""); 
    for( i = 0; i < as; i = i + 1 ){
//     printf("%ld",as);
//      printf("start");		
//      printf("%lf",a[i]);
//      printf("end");
      char buf[8];
      strcpy(buf, "");
      sprintf(buf,"%1f", a[i]);
//      strcat(buf, ",");
      strcat(message, buf);
      strcat(message, ",");	  
//	  puts(message);
//      printf("messageend");	  
    }	
    if( send(s, message, strlen(message), 0) < 0)
    {
        puts("Send failed");
        return 0;
    }
    
//    puts("Data Send\n");
         
        //Receive a reply from the server
    if((recv_size = recv(s , server_reply , 2000 , 0)) == SOCKET_ERROR)
    {
        puts("recv failed");
        return 0;
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
//    printf("Result : %d" , c[0]);

    return 1;
}
#endif	

int swap(int as, double a[],  char* host, int port, double c[])
{
 /* Detect the operation system and choose corresponding function to set up the socket connection . */	
 #ifdef __linux__ 
    linuxSocket(as, a,host, port,c);
 #elif _WIN32	
    winSocket(as, a,host, port,c);
 #endif	
 return 1;
}




