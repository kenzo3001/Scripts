#!/bin/bash

mostrar_uso() {
    echo "Uso: $0 <URL base> <arquivo de lista> <extensão de arquivo>"
    echo "Exemplo: $0 http://exemplo.com minha_lista.txt html"
    echo "Para não buscar arquivos específicos, passe a extensão como 'none'."
    exit 1
}

verificar_url() {
    local url=$1
    local status=$(curl -s -H "User-Agent: Mozilla/5.0" -o /dev/null -w "%{http_code}" "$url")
    echo $status
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    mostrar_uso
fi

URL_BASE=$1
ARQUIVO_LISTA=$2
EXTENSAO=$3

if [ ! -f "$ARQUIVO_LISTA" ]; then
    echo "Erro: Arquivo '$ARQUIVO_LISTA' não encontrado."
    exit 1
fi

while read -r palavra; do
    
    status_diretorio=$(verificar_url "$URL_BASE/$palavra/")
    if [ "$status_diretorio" == "200" ]; then
        echo "Diretório encontrado: $URL_BASE/$palavra/"
    fi

    if [ "$EXTENSAO" != "none" ]; then
        status_arquivo=$(verificar_url "$URL_BASE/$palavra.$EXTENSAO")
        if [ "$status_arquivo" == "200" ]; then
            echo "Arquivo encontrado: $URL_BASE/$palavra.$EXTENSAO"
        fi
    fi
done < "$ARQUIVO_LISTA"