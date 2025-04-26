param(
    [Parameter(Mandatory=$true)]
    [string]$ip,

    [Parameter(Mandatory=$false)]
    [int[]]$ports = @(21, 22, 25, 80, 443, 3306, 445)
)

Write-Host "`nIniciando varredura em $ip ..." -ForegroundColor Cyan

foreach ($porta in $ports) {
    try {
        $isPortOpen = Test-NetConnection -ComputerName $ip -Port $porta -WarningAction SilentlyContinue -InformationLevel Quiet

        if ($isPortOpen) {
            Write-Host "Porta $porta: Aberta" -ForegroundColor Green
        } else {
            Write-Host "Porta $porta: Fechada" -ForegroundColor Red
        }
    } catch {
        Write-Host "Erro ao testar a porta $porta. Verifique IP ou conexão." -ForegroundColor Yellow
    }
}

Write-Host "`n✅ Scan finalizado." -ForegroundColor Cyan
