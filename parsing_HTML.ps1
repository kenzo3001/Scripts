$site = Read-Host "Digite o site:"
try {
    $web = Invoke-WebRequest -uri "$site" -Method Options
        echo "O servidor roda: "
    $web.headers.server
        echo "____________________________________________"
        echo "O servidor aceita os metodos: "
    $web.headers.allow
        echo "____________________________________________"
        echo "Links encontrados: "
    $web2 = Invoke-WebRequest -uri "$site"
    $web2.links.href | Select-String http:// 
}
catch {}