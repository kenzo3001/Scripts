# Função para exibir a explicação antes de rodar
function mostrar_demo {
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "            🌐 PARSING HTML 🌐          " -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "➡️  O script obtém informações do servidor e os métodos HTTP aceitos."
    Write-Host "➡️  Além disso, extrai todos os links encontrados na página."
    Write-Host "➡️  Basta fornecer a URL completa (exemplo: http://exemplo.com)."
    Write-Host "=========================================" -ForegroundColor Cyan
    Start-Sleep -Seconds 3
}

# Exibir a explicação antes da execução
mostrar_demo

# Solicita a URL ao usuário
$site = Read-Host "Digite a URL completa (ex: http://site.com)"

try {
    # Tenta obter os headers do servidor com o método OPTIONS
    $web = Invoke-WebRequest -Uri "$site" -Method Options -ErrorAction Stop

    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host " 🖥️  Servidor identificado:" -ForegroundColor Green
    if ($web.Headers.Server) {
        Write-Host "   $($web.Headers.Server)" -ForegroundColor White
    } else {
        Write-Host "   ❌ Não informado pelo servidor." -ForegroundColor Red
    }

    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host " 📡 Métodos HTTP aceitos:" -ForegroundColor Green
    if ($web.Headers.Allow) {
        Write-Host "   $($web.Headers.Allow)" -ForegroundColor White
    } else {
        Write-Host "   ❌ O servidor não forneceu informações." -ForegroundColor Red
    }

    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host " 🔗 Links encontrados na página: " -ForegroundColor Green

    # Tenta obter os links da página pri
}