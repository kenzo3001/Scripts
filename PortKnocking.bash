#!/bin/bash

alvo="172.16.1."

portas=(13 37 30000 3000)

port_knocking() {
    local ip="$1"
    local resultados=""
    
    for porta in "${portas[@]}"; do
        if sudo hping3 -c 1 -S -p "$porta" "$ip" >/dev/null 2>&1; then
            resultados+="| \e[32m$ip\e[0m   | \e[32m$porta\e[0m | \e[32mOK\e[0m |\n"
            sleep 3
            curl -s "http://$ip:1337" && resultados+=" | \e[34mHTTP ACESSADO\e[0m |\n"
        else
            resultados+="| \e[31m$ip\e[0m  | \e[31m$porta\e[0m | \e[31mFALHA\e[0m |\n"
        fi
    done

    echo -e "$resultados"
    
}

echo "Iniciando Port Knocking em $alvo"
echo  ""
echo "________________________________________________"
printf "| \e[36m%-15s\e[0m| \e[36m%-15s\e[0m | \e[36m%-15s\e[0m |\n" "IP" "Porta" "Status"
echo "________________________________________________"

for i in {1..254}; do
    ip="$alvo$i"
    resultados=$(port_knocking "$ip")
    echo -e "$resultados"
done

echo ="________________________________________________"

echo "Port knocking em $alvo e nas portas ${portas[@]}"