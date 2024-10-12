//Bibliotecas
#include <stdio.h>
#include <sys/soket.h>
#include <netdb.h>
int main (int argc, char *argv){
		//Variaveis
		int meuSoket;
		int conecta;
		int porta;
		int inicio = 0;
		int final = 65535;
		char *destino;
		destino = argv[1];
		
		struct sokaddr_in alvo;
		
		for(porta = inicio;porta<final;porta++){
		//Socket
		meuSocket = soket(AF_INET, SOCK_STREAM, 0);
		alvo.sin_damily = AF_INET;
		alvo.sin_port=htons(porta);
		alvo.sin_addr.s_addr = inet_addr(destino);
		//Scan da porta
		conecta = conect(meuSocket, (struct sockddr *) &alvo, sizeof alvo));
		if(conecta == 0){
				printf("Porta %d - status: {ABERTA} \n", porta)
				close(meusocket);
				close(conecta)
		}else{
					close(meuSocket);
					close(conecta);
		}
}
}