param(
    [string]$ip
)

if (-not $ip) {
    Write-Host "Modo de uso: .\portscan.ps1 <IP>"
    exit
}

# Lista das portas mais comuns a serem verificadas
$topPorts = @(21, 22, 25, 80, 443, 3306, 445)

try {
    foreach ($porta in $topPorts) {
        # Testa a conexão na porta específica
        $isPortOpen = Test-NetConnection -ComputerName $ip -Port $porta -WarningAction SilentlyContinue -InformationLevel Quiet

        if ($isPortOpen) {
            Write-Host "Porta $porta: Aberta" -ForegroundColor Green
        } else {
            Write-Host "Porta $porta: Fechada" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "Ocorreu um erro ao tentar verificar as portas. Verifique o endereço IP ou sua conexão de rede." -ForegroundColor Yellow
}