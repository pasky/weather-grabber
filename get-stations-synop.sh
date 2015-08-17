#!/bin/bash
# Get data from synop weather stations.
# Usage: get-stations-synop.sh
# Refreshed once per hour.

ts=$(TZ=UTC date +%Y%m%d%H)
td=$(TZ=UTC date +%Y%m)

# http://pr-asv.chmi.cz/synopy-map/staniceasci.php
cat synop-list.txt | while read ind loc; do
	mkdir -p synop/$ind/$td
	# run multiple wgets potentially in parallel as the server is sometimes *real* slow
	./get -z "http://pr-asv.chmi.cz/synopy-map/pocasinaasci.php?indstanice=$ind" "synop/$ind/$td/${ts}.html.gz"
	sleep 1.1
done
