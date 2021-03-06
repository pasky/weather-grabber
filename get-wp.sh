#!/bin/bash
# Get vertical wind profile data
# ./get-wp.sh PERIOD HOUROFS
# Updated twice an hour, but since it's a 24h graph, we fetch
# it just twice a day.

[ $(($(TZ=UTC date +%_H) % $1)) -eq $2 ] || exit 0

ts=$(TZ=UTC date +%Y%m%d%H)
td=$(TZ=UTC date +%Y)

for ind in 11406 11480 11509 11520 11538 11698 11718; do
	mkdir -p wp/$ind/$td
	./get "http://portal.chmi.cz/files/portal/docs/meteo/oa/data_wp/${ind}.wp.png" "wp/$ind/$td/${ts}.png"
	sleep 2
done
