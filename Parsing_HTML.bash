#!bin/bash
if ["$1" == ""] ; then
    echo "Parsing HTML"
    echo "Modo de uso: $0 site.com"
else   
    wget -q "$1" -O -| grep -o 'http[s]\?://[^"]*' | cut -d '/' -f 3 | sort -u > dominios.txt
    echo ""
    echo "___________________________________________________"
    printf "| \e[1;34m%-30s\e[0m | \e[1;32m%-15s\e[0m |\n" "Domínio" "IP"
    echo "___________________________________________________"

    while IFS= read -r domain; do 
        ip=$(host "$domain" | awk '/has address/ {print $NF}')
        printf "| \e[1;34m%-30s\e[0m | \e[1;32m%-15s\e[0m |\n" "$domain" "$ip"
    done < dominios.txt
    
    echo "___________________________________________________"
fi