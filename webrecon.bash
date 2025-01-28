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

log_acao() {
    local mensagem=$1
    local tipo=$2
    local status_code=$3
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    if [ "$tipo" == "INFO" ]; then
        echo "[INFO] [$timestamp] $mensagem (Status HTTP: $status_code)"
    elif [ "$tipo" == "ERRO" ]; then
        echo "[ERRO] [$timestamp] $mensagem (Status HTTP: $status_code)" >&2
    else
        echo "[LOG] [$timestamp] $mensagem (Status HTTP: $status_code)"
    fi
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    mostrar_uso
fi

URL_BASE=$1
ARQUIVO_LISTA=$2
EXTENSAO=$3

if [ ! -f "$ARQUIVO_LISTA" ]; then
    log_acao "Arquivo '$ARQUIVO_LISTA' não encontrado." "ERRO" "N/A"
    exit 1
fi

log_acao "Iniciando varredura no URL base: $URL_BASE" "INFO" "N/A"

while read -r palavra; do
    log_acao "Verificando diretório: $URL_BASE/$palavra/" "INFO" "N/A"
    status_diretorio=$(verificar_url "$URL_BASE/$palavra/")
    log_acao "Resultado da verificação do diretório: $URL_BASE/$palavra/" "INFO" "$status_diretorio"
    if [ "$status_diretorio" == "200" ]; then
        log_acao "Diretório encontrado: $URL_BASE/$palavra/" "INFO" "$status_diretorio"
    fi

    if [ "$EXTENSAO" != "none" ]; then
        log_acao "Verificando arquivo: $URL_BASE/$palavra.$EXTENSAO" "INFO" "N/A"
        status_arquivo=$(verificar_url "$URL_BASE/$palavra.$EXTENSAO")
        log_acao "Resultado da verificação do arquivo: $URL_BASE/$palavra.$EXTENSAO" "INFO" "$status_arquivo"
        if [ "$status_arquivo" == "200" ]; then
            log_acao "Arquivo encontrado: $URL_BASE/$palavra.$EXTENSAO" "INFO" "$status_arquivo"
        fi
    fi

done < "$ARQUIVO_LISTA"

log_acao "Varredura concluída." "INFO" "N/A"
