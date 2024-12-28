#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <VARIAVEL1> <VARIAVEL2>"
    echo "Exemplo: $0 site.com pdf"
    exit 1
fi
VARIAVEL1=$1
VARIAVEL2=$2
TEMP_FILE=$(mktemp) 

echo "Iniciando a busca com lynx para site:$VARIAVEL1 e ext:$VARIAVEL2..."

lynx --dump "https://google.com/search?&q=site:$VARIAVEL1+ext:$VARIAVEL2" \
    | grep "\.$VARIAVEL2" \
    | cut -d "=" -f2 \
    | egrep -v "site|google" \
    | sed 's/...$//' > "$TEMP_FILE"

echo "URLs limpas salvas em $TEMP_FILE."

DOWNLOAD_DIR=$(mktemp -d) 
echo "Baixando arquivos no diretório $DOWNLOAD_DIR..."

while IFS= read -r URL; do
    echo "Baixando: $URL"
    wget -q -P "$DOWNLOAD_DIR" "$URL"
done < "$TEMP_FILE"

echo "Análise de metadados com exiftool..."
exiftool "$DOWNLOAD_DIR"/*


echo "Limpando arquivos temporários..."

rm -f "$TEMP_FILE"
rm -rf "$DOWNLOAD_DIR"

echo "Processo concluído!"
