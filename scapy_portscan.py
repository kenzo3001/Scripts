#!/usr/bin/python3
import sys
from scapy.all import IP, TCP, sr

def mostrar_demo():
    print("\nDemonstração do funcionamento do script:")
    print("$ python3 scan_ports.py <IP-alvo>")
    print("Exemplo: python3 scan_ports.py 192.168.1.1\n")

def escanear_portas(alvo):
    portas = [21, 22, 23, 25, 80, 443, 110]
    print(f"Escaneando {alvo} nas portas: {portas}\n")
    
    pacote_ip = IP(dst=alvo)
    pacote_tcp = TCP(dport=portas, flags="S")
    pacote = pacote_ip / pacote_tcp
    
    print("[DEBUG] Enviando pacotes...")
    resp, sem_resposta = sr(pacote, timeout=2, verbose=1)
    
    if not resp:
        print("[DEBUG] Nenhuma resposta recebida. Verifique o firewall do destino ou tente rodar como root.")
    
    for envio, resposta in resp:
        if TCP in resposta:
            porta = resposta[TCP].sport
            flag = resposta[TCP].flags
            print(f"[DEBUG] Resposta recebida: Porta={porta}, Flags={flag}")
            
            if flag == 0x12: 
                print(f"Porta {porta} ABERTA")
        else:
            print("[DEBUG] Resposta sem TCP, possivelmente ICMP indicando porta fechada ou filtrada.")
        
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python3 scan_ports.py <IP-alvo>")
        mostrar_demo()
        sys.exit(1)
    
    alvo = sys.argv[1]
    escanear_portas(alvo)
