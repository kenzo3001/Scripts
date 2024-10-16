import sys
import socket

def verifica_portas(host):
    for porta in range(1, 65535):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as meu_socket:
            meu_socket.settimeout(1)  # Definir um timeout para evitar travamento
            if meu_socket.connect_ex((host, porta)) == 0:
                print(f"Porta: {porta} [ABERTA]")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Uso: {sys.argv[0]} <endereço>")
        sys.exit(1)
    
    host = sys.argv[1]
    try:
        socket.gethostbyname(host)  # Verifica se o host é válido
        verifica_portas(host)
    except socket.gaierror:
        print(f"Host inválido: {host}")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\nExecução interrompida pelo usuário.")
        sys.exit(0)
