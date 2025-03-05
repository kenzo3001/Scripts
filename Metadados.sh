#!/bin/bash

# Exibe uma explicação antes da execução
mostrar_demo() {
    echo "=============================================="
    echo "              🔍 METADADOS 🔍"
    echo "=============================================="
    echo "➡️  O script busca arquivos de um tipo específico em um site usando o Google."
    echo "➡️  Baixa os arquivos encontrados e analisa seus metadados com exiftool."
    echo "➡️  Uso: $0 <site> <extensão>"
    echo "➡️  Exemplo: $0 site.com pdf"
    echo "=========================================="
    sleep 3
}

# Verifica se os argumentos foram fornecidos
if [ "$#" -ne 2 ]; then
    echo "❌ Uso incorreto!"
    echo "Modo correto: $0 <site> <extensão>"
    echo "Exemplo: $0 site.com pdf"
    exit 1
fi

mostrar_demo  # Mostra a explicação antes de rodar o script

VARIAVEL1=$1  # Site alvo
VARIAVEL2=$2  # Extensão do arquivo
TEMP_FILE=$(mktemp)  # Arquivo temporário para salvar URLs

echo "🔍 Buscando arquivos .$VARIAVEL2 em $VARIAVEL1..."
lynx --dump "https://google.com/search?&q=site:$VARIAVEL1+ext:$VARIAVEL2" \
    | grep -oE "https?://[^ ]+\.$VARIAVEL2" \
    | egrep -v "site|google" > "$TEMP_FILE"

if [ ! -s "$TEMP_FILE" ]; then
    echo "❌ Nenhuma URL encontrada. Saindo..."
    rm -f "$TEMP_FILE"
    exit 1
fi

echo "✅ URLs extraídas e salvas em $TEMP_FILE."

DOWNLOAD_DIR=$(mktemp -d)  # Diretório temporário para downloads
echo "📂 Baixando arquivos para $DOWNLOAD_DIR..."

while IFS= read -r URL; do
    echo "⬇️  Baixando: $URL"
    wget -q --show-progress -P "$DOWNLOAD_DIR" "$URL" || echo "⚠️ Erro ao baixar $URL"
done < "$TEMP_FILE"

echo "📊 Analisando metadados dos arquivos baixados..."
exiftool "$DOWNLOAD_DIR"/*

echo "🧹 Limpando arquivos temporários..."
rm -f "$TEMP_FILE"
rm -rf "$DOWNLOAD_DIR"

echo "✅ Processo concluído!"
