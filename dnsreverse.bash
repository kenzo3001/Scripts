#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Uso: $0 <IP base> <intervalo inicial> <intervalo final>"
    exit 1
fi

BASE_IP=$1
START_RANGE=$2
END_RANGE=$3

if [ "$START_RANGE" -gt "$END_RANGE" ]; then
    echo "Erro: O intervalo inicial deve ser menor ou igual ao intervalo final."
    exit 1
fi

for ip in $(seq "$START_RANGE" "$END_RANGE"); do
    FULL_IP="$BASE_IP.$ip"
    REVERSE_DNS=$(host -t ptr "$FULL_IP" 2>/dev/null)

    if [ -n "$REVERSE_DNS" ] && echo "$REVERSE_DNS" | grep -q "pointer"; then
            echo "$FULL_IP - $(echo "$REVERSE_DNS" | grep "pointer")"
        else
            echo "$FULL_IP - Nenhum registro PTR encontrado"
    fi
done