#!/bin/bash
# Get vertical wind profile data
# ./get-wp.sh
# Updated twice an hour, but since it's a 24h graph, we fetch
# it just twice a day.

ts=$(TZ=UTC date +%Y%m%d%H)

for ind in 11406 11480 11509 11520 11538 11698 11718; do
	mkdir -p wp/$ind
	wget -q -O "wp/$ind/${ts}.png" "http://portal.chmi.cz/files/portal/docs/meteo/oa/data_wp/${ind}.wp.png"
	wgetstatus=$?
	if [ $wgetstatus -ne 0 ]; then
		echo "wget http://portal.chmi.cz/files/portal/docs/meteo/oa/data_wp/${ind}.wp.png failed $wgetstatus" >&2
	fi
	sleep 2
done
