import requests
import argparse

security_headers = [
    "Strict-Transport-Security",    
    "Content-Security-Policy",      
    "X-Content-Type-Options",       
    "X-Frame-Options",              
    "X-XSS-Protection",             
    "Referrer-Policy",              
]

def verificar_cabecalhos_seguranca(url):
    try:
        resposta = requests.get(url, timeout=5)
        headers = resposta.headers

        print(f"Verificando cabeçalhos de segurança para {url}...\n")

        for header in security_headers:
            if header in headers:
                print(f"[+] {header}: Encontrado - {headers[header]}")
            else:
                print(f"[-] {header}: Não encontrado")

    except requests.exceptions.Timeout:
        print(f"Erro: Tempo de conexão esgotado para {url}.")
    except requests.exceptions.RequestException as e:
        print(f"Erro ao acessar o site {url}: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Verificar cabeçalhos de segurança de um site.")
    parser.add_argument("url", help="URL do site a ser verificado")
    args = parser.parse_args()

    if not args.url.startswith(('http://', 'https://')):
        args.url = 'http://' + args.url

    verificar_cabecalhos_seguranca(args.url)
