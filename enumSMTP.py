#!/usr/bin/python3
import socket
import sys
import os
import re

def main():
    if len(sys.argv) != 3:
        print("Modo de uso: python3 smtpenum.py <IP> <usuario_ou_arquivo.txt>")
        sys.exit(0)

    ip = sys.argv[1]
    entrada = sys.argv[2]

    # Verifica se é um arquivo ou um único usuário
    if os.path.isfile(entrada):
        try:
            with open(entrada, 'r') as file:
                usuarios = [linha.strip() for linha in file if linha.strip()]
        except FileNotFoundError:
            print(f"Arquivo '{entrada}' não encontrado.")
            sys.exit(0)
    else:
        usuarios = [entrada]

    try:
        tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        tcp.settimeout(5)

        tcp.connect((ip, 25))

        banner = tcp.recv(1024)
        print("Banner recebido:")
        print(banner.decode().strip())

        for usuario in usuarios:
            comando = f"VRFY {usuario}\r\n"
            tcp.sendall(comando.encode())

            resposta = tcp.recv(1024)
            resposta_decodificada = resposta.decode().strip()
            print(f"Usuário: {usuario} -> Resposta: {resposta_decodificada}")
            if re.search(r"252", resposta_decodificada):
                resultado = re.sub(r"^252.*?:", "", resposta_decodificada).strip()
                print(f"✅ Usuário encontrado: {resultado or usuario}")

    except socket.timeout:
        print("Conexão expirou (timeout).")
    except socket.error as err:
        print(f"Erro de socket: {err}")
    finally:
        tcp.close()

if __name__ == "__main__":
    main()
