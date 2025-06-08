#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>

#define TAM_MAX 256

void mostrar_demo() {
    printf("==========================================\n");
    printf("           🔍 DNS RESOLVER 🔍            \n");
    printf("==========================================\n");
    printf("➡️  O script tenta resolver subdomínios de um alvo usando uma lista de prefixos.\n");
    printf("➡️  Ele concatena cada subdomínio ao domínio principal e busca o IP correspondente.\n");
    printf("➡️  Exemplo de uso: ./dns_resolver alvo.com.br lista.txt\n");
    printf("------------------------------------------\n\n");
    sleep(3);
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("❌ Uso incorreto!\n");
        printf("Modo correto: %s <domínio> <arquivo_lista>\n", argv[0]);
        return 1;
    }

    mostrar_demo();

    char *alvo = argv[1];
    FILE *arquivo = fopen(argv[2], "r");
    
    if (!arquivo) {
        perror("Erro ao abrir o arquivo");
        return 1;
    }

    char subdominio[TAM_MAX];
    while (fscanf(arquivo, "%s", subdominio) != EOF) {
        char resultado[TAM_MAX];
        snprintf(resultado, TAM_MAX, "%s.%s", subdominio, alvo); 

        struct addrinfo hints, *res;
        memset(&hints, 0, sizeof(hints));
        hints.ai_family = AF_INET;
        hints.ai_socktype = SOCK_STREAM;

        if (getaddrinfo(resultado, NULL, &hints, &res) == 0) {
            struct sockaddr_in *addr = (struct sockaddr_in *)res->ai_addr;
            printf("🔹 HOST ENCONTRADO: %s ==> IP: %s\n", resultado, inet_ntoa(addr->sin_addr));
            freeaddrinfo(res);
        }
    }

    fclose(arquivo);
    printf("\n✅ Varredura concluída!\n");
    return 0;
}
