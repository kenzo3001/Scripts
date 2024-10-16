import socket

ip = input("Digite o IP: ")
porta = int(input("Digite a porta: "))

try:
    meuSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    meuSocket.connect((ip, porta))
    banner = meuSocket.recv(4096) #receber até 4kb de dados
    print(banner.decode())
except socket.error as err:
    print(f"Erro de conexão: {err}")
