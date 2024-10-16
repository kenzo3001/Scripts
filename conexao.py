import socket
import argparse

def conectar(ip, porta, usuario, senha):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as meu_socket:
            meu_socket.settimeout(5)  # Definir timeout para evitar travamento
            meu_socket.connect((ip, porta))

            # Recebe e exibe o banner inicial
            banner = meu_socket.recv(1024)
            print(f"Banner recebido: {banner.decode()}")

            # Envia o nome de usuário
            print(f"Enviando usuário: {usuario}")
            meu_socket.sendall(f"USER {usuario}\r\n".encode())
            resposta = meu_socket.recv(1024)
            print(f"Resposta ao usuário: {resposta.decode()}")

            # Envia a senha
            print(f"Enviando senha: {senha}")
            meu_socket.sendall(f"PASS {senha}\r\n".encode())
            resposta = meu_socket.recv(1024)
            print(f"Resposta à senha: {resposta.decode()}")

    except socket.timeout:
        print("Tempo de conexão esgotado.")
    except ConnectionRefusedError:
        print(f"Conexão recusada em {ip}:{porta}.")
    except socket.gaierror:
        print("Endereço IP inválido.")
    except socket.error as e:
        print(f"Erro de socket: {e}")
    except KeyboardInterrupt:
        print("\nExecução interrompida pelo usuário.")

if __name__ == "__main__":
    # Usando argparse para receber IP, porta, usuário e senha via linha de comando
    parser = argparse.ArgumentParser(description="Conectar a um servidor e enviar credenciais.")
    parser.add_argument("ip", help="Endereço IP do servidor")
    parser.add_argument("porta", type=int, help="Porta do servidor")
    parser.add_argument("usuario", help="Usuário para autenticação")
    parser.add_argument("senha", help="Senha para autenticação")

    args = parser.parse_args()

    # Verifica se a porta é válida
    if args.porta < 1 or args.porta > 65535:
        print("Porta inválida! Escolha um número entre 1 e 65535.")
    else:
        # Verifica se o IP é válido e tenta se conectar
        try:
            socket.gethostbyname(args.ip)
            conectar(args.ip, args.porta, args.usuario, args.senha)
        except socket.gaierror:
            print("Endereço IP inválido.")
        except KeyboardInterrupt:
            print("\nExecução interrompida pelo usuário.")
