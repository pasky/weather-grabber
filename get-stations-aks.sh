#!/bin/bash
# Get data from aks weather stations (automatic 10m resolution data feed).
# Usage: get-stations-aks.sh
# This data is available in 48h plot form, so we fetch it just once a day.

ts=$(TZ=UTC date +%Y%m%d%H)
td=$(TZ=UTC date +%Y)

# for p in BR CB HK OS PL PR UL; do curl http://portal.chmi.cz/files/portal/docs/poboc/OS/KW/Captor/pobocka.$p.1.html; done | grep gif | cut -d \" -f 6
cat aks-list.txt | while read id; do
	mkdir -p aks/$id/$td
	wget -q -O "aks/$id/$td/${ts}.gif" "http://portal.chmi.cz/files/portal/docs/poboc/OS/KW/Captor/tmp/DMULTI-${id}.gif"
	wgetstatus=${PIPESTATUS[0]}
	[ $wgetstatus -eq 0 ] || echo "http://portal.chmi.cz/files/portal/docs/poboc/OS/KW/Captor/tmp/DMULTI-${id}.gif wget error status $wgetstatus" >&2
	sleep 0.4
done
