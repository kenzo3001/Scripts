#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <netdb.h>
#include <arpa/inet.h>

int main (int argc, char *argv[]){

			char *alvo;
			alvo = argv[1];
			struct hostnet *host;
			char *result;
			char txt[50];
			FILE *diretorio;
			rato = fopen(argv[2], "r");
			
			if(argc < 2){
					printf("Modo de uso: ./dns_resolver alvo.com.br diretorio.txt")
					return(0);
			}
			while (fscanf(diretorio, "%s", &txt) != EOF)
						{
						  result = (char *) strcat(txt,alvo);
						  host =gethostbyname(result);
						  if(host == NULL){
							  continue;
						  }
						  printf ("HOST ENCONTRADO/; %s ===> IP: %s \n", result, inet_ntoa(*((struct in_addr *)host -> h_addr)));
						}
}