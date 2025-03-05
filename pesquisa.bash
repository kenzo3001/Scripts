#!/bin/bash

# Função para exibir a explicação antes da execução
mostrar_demo() {
    echo "========================================="
    echo " 🔍 Script de Busca no Google (Lynx) 🔍 "
    echo "========================================="
    echo "➡️  O script pesquisa arquivos com uma determinada extensão."
    echo "➡️  Ele busca no Google usando o Lynx e extrai as URLs."
    echo "➡️  Exemplo: $0 exemplo.com pdf"
    echo "========================================="
    sleep 2
}

# Função para exibir o uso correto
mostrar_uso() {
    echo "Uso: $0 <domínio> <extensão>"
    echo "Exemplo: $0 exemplo.com pdf"
    exit 1
}

# Exibir a explicação antes de rodar
mostrar_demo

# Verifica se os parâmetros foram passados
if [ -z "$1" ] || [ -z "$2" ]; then
    mostrar_uso
fi

DOMINIO=$1
EXTENSAO=$2

# Verifica se o Lynx está instalado
if ! command -v lynx &>/dev/null; then
    echo "❌ Erro: O Lynx não está instalado. Instale com 'sudo apt install lynx' ou equivalente."
    exit 1
fi

echo "🔎 Buscando arquivos .$EXTENSAO no domínio $DOMINIO..."
sleep 2

# Realiza a busca no Google
lynx --dump "http://www.google.com/search?num=500&q=site:$DOMINIO+ext:$EXTENSAO" -useragent="Mozilla/5.0" | \
    grep -Eo "https?://[^ ]+\.$EXTENSAO" | \
    sort -u > resultados.txt

# Exibe os resultados encontrados
if [ -s resultados.txt ]; then
    echo "✅ URLs encontradas:"
    cat resultados.txt
else
    echo "❌ Nenhuma URL encontrada para '$DOMINIO' com a extensão '$EXTENSAO'."
    rm -f resultados.txt
fi
