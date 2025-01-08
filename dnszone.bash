#!/bin/bash
if [ -z "$1" ]; then
    echo "Uso: $0 <URL>"
    exit 1
fi
URL=$1

NS_OUTPUT=$(host -t ns "$URL" | cut -d " " -f4)

if [ -z "$NS_OUTPUT" ]; then
    echo "Nenhum servidor NS encontrado para $URL"
    exit 1
fi

for NS in $NS_OUTPUT; do
    echo "Executando host -l em $NS:"
    host -l "$1" "$NS"
done