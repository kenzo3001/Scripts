import socket
from whois import whois
import ipaddress
import argparse

def is_ip(address):
    """Verifica se o endereço é um IP (IPv4 ou IPv6)."""
    try:
        ipaddress.ip_address(address)
        return True
    except ValueError:
        return False

def query_whois_via_socket(address):
    """Consulta WHOIS usando sockets para IPs ou domínios."""
    try:
        # Conexão com o servidor WHOIS da IANA
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect(("whois.iana.org", 43))
            s.sendall(f"{address}\r\n".encode("utf-8"))
            response = b""
            while True:
                data = s.recv(4096)
                if not data:
                    break
                response += data
        response_decoded = response.decode("utf-8")
        print("Resposta da IANA:")
        print(response_decoded)

        # Extrai o servidor WHOIS específico da resposta
        whois_server = None
        for line in response_decoded.splitlines():
            if line.lower().startswith("refer:" ):
                whois_server = line.split(":", 1)[1].strip()
                break

        if not whois_server:
            print("Servidor WHOIS não encontrado na resposta.")
            return

        print(f"Conectando ao servidor WHOIS: {whois_server}")

        # Conexão com o servidor WHOIS específico
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s1:
            s1.connect((whois_server, 43))
            s1.sendall(f"{address}\r\n".encode("utf-8"))
            detailed_response = b""
            while True:
                data = s1.recv(4096)
                if not data:
                    break
                detailed_response += data
        print("Resposta detalhada:")
        print(detailed_response.decode("utf-8"))

    except Exception as e:
        print(f"Erro ao realizar consulta WHOIS via socket: {e}")

def query_whois(address):
    """Realiza a consulta WHOIS para um host, IPv4 ou IPv6."""
    if is_ip(address):
        print(f"Realizando consulta WHOIS para IP: {address}")
        query_whois_via_socket(address)
    else:
        try:
            print(f"Realizando consulta WHOIS para domínio: {address}")
            domain_info = whois(address)
            print("Informações do domínio obtidas pela biblioteca whois:")
            print(domain_info)
        except Exception as e:
            print(f"Erro ao consultar o WHOIS para domínio usando a biblioteca whois: {e}")
            print("Tentando consulta via socket...")
            query_whois_via_socket(address)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Consulta WHOIS para host, IPv4 ou IPv6.")
    parser.add_argument("address", type=str, help="Host, IPv4 ou IPv6 a ser consultado")
    args = parser.parse_args()

    query_whois(args.address)
