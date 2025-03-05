#!/bin/bash

# Exibe uma explicação antes da execução
mostrar_demo() {
    echo "========================================="
    echo "          🌐 PARSING HTML 🌐            "
    echo "========================================="
    echo "➡️  O script baixa o HTML de um site e extrai os domínios contidos nele."
    echo "➡️  Depois, faz a resolução de IP para cada domínio encontrado."
    echo "➡️  Uso: $0 <site.com>"
    echo "➡️  Exemplo: $0 exemplo.com"
    echo "========================================="
    sleep 3
}

# Verifica se o argumento foi fornecido
if [ -z "$1" ]; then
    echo "❌ Erro: Nenhum domínio fornecido!"
    echo "Modo correto: $0 <site.com>"
    exit 1
fi

mostrar_demo  # Exibe a explicação antes de rodar

SITE=$1

echo "🔍 Extraindo domínios do site $SI
