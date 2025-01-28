#!/bin/bash

mostrar_uso() {
    echo "Uso: $0 <domínio> <extensão>"
    echo "Exemplo: $0 exemplo.com pdf"
    exit 1
}

if [ -z "$1" ] || [ -z "$2" ]; then
    mostrar_uso
fi

DOMINIO=$1
EXTENSAO=$2

lynx --dump "http://google.com/search?num=500&q=site:$DOMINIO+ext:$EXTENSAO" | \
    grep "\.$EXTENSAO" | \
    cut -d "=" -f2 | \
    egrep -v "site|google" | \
    sed 's/...$//' > resultados.txt
if [ -s resultados.txt ]; then
    echo "URLs encontradas:"
    cat resultados.txt
else
    echo "Nenhuma URL encontrada para o domínio '$DOMINIO' com a extensão '$EXTENSAO'."
    rm -f resultados.txt
fi