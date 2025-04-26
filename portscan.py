import sys
import socket
import argparse
import concurrent.futures

# Função para escanear uma única porta
def verifica_porta(host, porta, timeout):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as meu_socket:
            meu_socket.settimeout(timeout)
            if meu_socket.connect_ex((host, porta)) == 0:
                try:
                    servico = socket.getservbyport(porta)
                except OSError:
                    servico = "Desconhecido"
                print(f"\033[92m[ABERTA]\033[0m Porta {porta} ({servico})")
    except Exception:
        pass

# Função principal
def verifica_portas(host, start, end, timeout, threads):
    print(f"\n🔎 Iniciando scan em {host} - Portas {start} a {end}\n")
    with concurrent.futures.ThreadPoolExecutor(max_workers=threads) as executor:
        for porta in range(start, end + 1):
            executor.submit(verifica_porta, host, porta, timeout)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Scanner de portas simples")
    parser.add_argument("host", help="Endereço IP ou hostname para escanear")
    parser.add_argument("--start", type=int, default=1, help="Porta inicial (padrão: 1)")
    parser.add_argument("--end", type=int, default=65535, help="Porta final (padrão: 65535)")
    parser.add_argument("--timeout", type=float, default=1, help="Timeout por conexão em segundos (padrão: 1)")
    parser.add_argument("--threads", type=int, default=100, help="Número de threads simultâneas (padrão: 100)")
    args = parser.parse_args()

    try:
        socket.gethostbyname(args.host)
        verifica_portas(args.host, args.start, args.end, args.timeout, args.threads)
    except socket.gaierror:
        print(f"\033[91mHost inválido:\033[0m {args.host}")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\n\033[93mExecução interrompida pelo usuário.\033[0m")
        sys.exit(0)
