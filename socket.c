#include <stdio.h>
#include <sys/soket.h>
#include <netdb.h>
int main (void){
		int meuSoket;
		int conecta;
		
		struct sokaddr_in alvo;
		
		meuSocket = soket(AF_INET, SOCK_STREAM, 0);
		alvo.sin_damily = AF_INET;
		alvo.sin_port=htons(80);
		alvo.sin_addr.s_addr = inet_addr("192.162.0.1")
		
		conecta = conect(meuSocket, (struct sockddr *) &alvo, sizeof alvo));
		if(conecta == 0){
				printf("Porta aberta \n")
				close(meusocket);
				close(conecta)
		} else{
			printf("Porta Fechada \n")
		}
}