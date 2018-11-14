/* Function that exchange data with an external object via socket connection.
 *
 * Sen Huang, PNNL                     2018-07-09
 */

#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<assert.h>
#include "json.h"
/*#include<ModelicaUtilities.h>*/



/* Detect the operation system and choose corresponding dependencies to set up the socket connection. */
#ifdef __linux__
#include<sys/socket.h>
#include<arpa/inet.h>
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
#endif


int sendmessage(int numvar, double var[], char** varNam, char** varUni, double simTim, char* host, int port)
{
	struct sockaddr_in server;
	char *message;
	JsonNode *root;
	int result;


	/* Set the socket. */
#ifdef _WIN32 
	WSADATA wsa;
	SOCKET sock;
	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
	{
		/*ModelicaError("Error: Socket failed for the sockclient.c");*/
		return 1;
	}
#elif __linux__
	int sock;
#endif

	/* Create socket. */
	sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock == -1)
	{
		/*ModelicaError("Error: Could not create socket for the send function in the sockclient.c");*/
		return 1;
	}

	/*    ModelicaMessage("Socket created \n");*/
	server.sin_addr.s_addr = inet_addr(host);
	server.sin_family = AF_INET;
	server.sin_port = htons(port);

	/* Connect to remote server. */
	if (connect(sock, (struct sockaddr *)&server, sizeof(server)) < 0)
	{
		/*ModelicaError("Error: socket connect failed for the send function in the sockclient.c");*/
		return 1;
	}

	/*    ModelicaMessage("Socket connected \n");*/

	 /*
	 Example message:
	 {
		 varNam[i]: {"type":"Double",
					"value": var[i],
					"unit": varUni[i],
					"time": simTim},
		 varNam[i+1]: {"type":"Double",
					"value": var[i+1],
					"unit": varUni[i+1],
					"time": simTim},
		 ...
	 }
	 */

	root = json_mkobject();
	int i;
	for (i = 0; i < numvar; i = i + 1) {
		JsonNode *member = json_mkobject();
		json_append_member(member, "type", json_mkstring("Double"));
		json_append_member(member, "value", json_mknumber(var[i]));
		json_append_member(member, "unit", json_mkstring(varUni[i]));
		json_append_member(member, "time", json_mknumber(simTim));

		json_append_member(root, varNam[i], member);
	}

	message = json_encode(root);

	/* ModelicaMessage("Message created \n");*/
	/* Send data to remote server. */
	result = send(sock, message, strlen(message), 0);

	json_delete(root);
	free(message);

	if (result < 0)
	{
		/*ModelicaError("Error: socket message failed to be sent for the sockclient.c");*/
		return 1;
	}
	/* ModelicaMessage("Message sent \n");*/
	/* Receive data to remote server. */

#ifdef __linux__
	close(sock);
#elif _WIN32
	closesocket(sock);
	WSACleanup();
#endif
	/*ModelicaMessage("Socket closed \n");*/
	return 0;
}

int recimessage(int numvar, char** varNam, double simTim, char* host, int port, double oveSig[], double* ovesamplePeriod, double derSig[], int enableFlag[])
{
	struct sockaddr_in server;
	char server_reply[8000];

	char *message;
	JsonNode *root;
	int result;
	JsonNode *member;

	puts("run");

	/* Set the socket. */
#ifdef _WIN32 
	WSADATA wsa;
	SOCKET sock;
	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
	{
		/*ModelicaError("Error: Socket failed for the sockclient.c");*/
		return 1;
	}
#elif __linux__
	int sock;
#endif

	/* Create socket. */
	sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock == -1)
	{
		/*ModelicaError("Error: Could not create socket for the send function in the sockclient.c");*/
		return 1;
	}

	/*    ModelicaMessage("Socket created \n");*/
	server.sin_addr.s_addr = inet_addr(host);
	server.sin_family = AF_INET;
	server.sin_port = htons(port);

	/* Connect to remote server. */
	if (connect(sock, (struct sockaddr *)&server, sizeof(server)) < 0)
	{
		/*ModelicaError("Error: socket connect failed for the send function in the sockclient.c");*/
		return 1;
	}

	/*    ModelicaMessage("Socket connected \n");*/

	/*
	 Example message:
	 [
	   varNam[i],
	   varNam[i+1],
	   ...,
	   simTim
	 ]
	 */

	root = json_mkarray();
	int i;
	for (i = 0; i < numvar; i = i + 1) {
		json_append_element(root, json_mkstring(varNam[i]));
	}
	json_append_element(root, json_mknumber(simTim));
	message = json_encode(root);

	/* ModelicaMessage("Message created \n");*/
	/* Send data to remote server. */
	result = send(sock, message, strlen(message), 0);

	json_delete(root);
	free(message);

	/* ModelicaMessage("Message created \n");*/
	/* Send data to remote server. */

	if (result < 0)
	{
		/*ModelicaError("Error: socket message failed to be sent for the sockclient.c");*/
		return 1;
	}
	/* ModelicaMessage("Message sent \n");*/
	/* Receive data to remote server. */

	if (recv(sock, server_reply, 8000, 0) < 0)
	{
		/*ModelicaError("Error: socket message failed to be received for the sockclient.c");*/
		return 1;
	}
	if (strlen(server_reply) == 8000)
	{
		/*ModelicaError("Error: Not enough memory for the sockclient.c");*/
		return 1;
	}
	/*ModelicaMessage("Message received \n");*/



	/* Process data to remote server. */

	root = json_decode(server_reply);

	if (root == NULL)
	{
		/*ModelicaError("Error: failed to parse response to request in sockclient.c");*/
		return 1;
	}

	if (root->tag != JSON_OBJECT)
	{
		/*ModelicaError("Error: response to request in wrong format in sockclient.c");*/
		json_delete(root);
		return 1;
	}

	for (i = 0; i < numvar; i = i + 1) 
	{
		member = json_find_member(root, varNam[i]);
		if (member == NULL)
		{
			/*ModelicaError("Error: data missing from response in sockclient.c");*/
			json_delete(root);
			return 1;
		}

		JsonNode *child;

		child = json_find_member(member, "value");
		if (child != NULL && child->tag == JSON_NUMBER)
		{
			oveSig[i] = child->number_;
		}
		else
		{
			/*ModelicaError("Error: value data missing or wrong type in sockclient.c");*/
			json_delete(root);
			return 1;

		}

		child = json_find_member(member, "enable");
		if (child != NULL && child->tag == JSON_BOOL)
		{
			enableFlag[i] = child->bool_;
		}
		else
		{
			/*ModelicaError("Error: value data missing or wrong type in sockclient.c");*/
			json_delete(root);
			return 1;
		}

		child = json_find_member(member, "derivative");
		derSig[i] = (child != NULL && child->tag == JSON_NUMBER) ? child->number_ : 0;

		child = json_find_member(member, "nextSampleTime");
		if(child != NULL && child->tag == JSON_NUMBER)
		{
			*ovesamplePeriod = child->number_;
		}
	}

	json_delete(root);

#ifdef __linux__
	close(sock);
#elif _WIN32
	closesocket(sock);
	WSACleanup();
#endif
	/*ModelicaMessage("Socket closed \n");*/
	return 0;
}

