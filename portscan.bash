#!/bin/bash
if ["$1" == ""]
then
		echo "Modo de uso: $0 REDE PORTA"
		echo "Exemplo: $0 192.168.0 PORTA"
else
for ips in {1..254};
do
hping3 -S -p $2 -c 1 $1.$ip 2> /dev/null | grep "flags=SA" | cut -d " "-f 2
| cut -f "=" -f 2;
done
fi