param($ip)
if (!$ip){
    echo "Modo de uso: .\portscan.ps1 192.168.0.1"
}else{
$topPorts = 21,22,25,80,443,3306,445 
try {
    foreach ($porta in $topPorts) {
        if (Test-NetConnection $ip -Port $porta -WarningAction SilentlyContinue -InformationLevel Quiet){
	        echo "Porta $porta Aberta"
}} else{
	    echo "Porta $porta Fechada"
}
catch {}
}
}