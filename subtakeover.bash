#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <arquivo_txt> <domínio>"
    exit 1
fi

arquivo_txt="$1"

if [ ! -f "$arquivo_txt" ]; then
    echo "Erro: Arquivo '$arquivo_txt' não encontrado."
    exit 1
fi

dominio="$2"

while IFS= read -r palavra; do
    resultado1=$(host -t cname "$palavra.$dominio" 2>/dev/null | grep "alias for" | awk '{print $NF}')
    if [ -n "$resultado1" ]; then
        resultado2=$(host -t cname "$resultado1" 2>/dev/null | grep "alias for" | awk '{print $NF}')        
        echo "$palavra.$dominio -> $resultado1 -> ${resultado2:-N/A}"
    fi
done < "$arquivo_txt"
