import socket
import time

def mostrar_demo():
    """Exibe uma demonstração do funcionamento do script antes da execução."""
    print("\n" + "="*50)
    print("       🚀 BANNER GRABBING 🚀      ")
    print("="*50 + "\n")
    print("🔹 O script se conecta a um IP e porta específicos para capturar banners.")
    print("🔹 Pode ser útil para identificar serviços rodando em uma porta.")
    print("\n🔹 Exemplo de uso:")
    print("   ➤ IP: 192.168.1.1")
    print("   ➤ Porta: 22 (SSH)")
    print("   ➤ Resposta: OpenSSH 7.9p1 Debian-10+deb10u2\n")
    print("🔹 Se a porta estiver fechada ou protegida, a conexão falhará.\n")
    time.sleep(3)  # Pequena pausa para leitura

def obter_banner(ip, porta):
    """Tenta se conectar ao IP e porta especificados para capturar um banner."""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as meu_socket:
            meu_socket.settimeout(5)  # Define um timeout de 5 segundos
            meu_socket.connect((ip, porta))
            banner = meu_socket.recv(4096)  # Recebe até 4 KB de dados
            return banner.decode().strip()
    except socket.timeout:
        return "Erro: Conexão expirou (timeout)."
    except ConnectionRefusedError:
        return "Erro: Conexão recusada. A porta pode estar fechada."
    except socket.error as err:
        return f"Erro de conexão: {err}"

if __name__ == "__main__":
    mostrar_demo()

    ip = input("Digite o IP: ").strip()
    while True:
        try:
            porta = int(input("Digite a porta: ").strip())
            if 0 <= porta <= 65535:
                break
            else:
                print("⚠️  A porta deve estar entre 0 e 65535.")
        except ValueError:
            print("⚠️  Digite um número válido para a porta.")

    print("\n🔍 Tentando capturar banner...")
    resultado = obter_banner(ip, porta)

    print("\n📜 Resposta do servidor:")
    print("="*50)
    print(resultado)
    print("="*50)
