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
	(
		wget -q -O - "http://pr-asv.chmi.cz/synopy-map/pocasinaasci.php?indstanice=$ind" | gzip >"synop/$ind/$td/${ts}.html.gz"
		wgetstatus=${PIPESTATUS[0]}
		[ $wgetstatus -eq 0 ] || echo "http://pr-asv.chmi.cz/synopy-map/pocasinaasci.php?indstanice=$ind wget error status $wgetstatus" >&2
	) &
	sleep 1.1
done
