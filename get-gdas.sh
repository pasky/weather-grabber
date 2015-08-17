#!/bin/bash
# Get GDAS *global* observation summaries.
# ./get-gdas.sh PERIOD HOUROFS
# Updated every six hours.
#
# We assume that HOUROFS > PERIOD, unlike in all other scripts.
#
# Global Data Acquisition System integrates data from a huge number
# of world-wide sources to build a grid of various variables:
#	https://ready.arl.noaa.gov/gdas1.php
# We grab the 1-degree grid resolution.

[ $(($(TZ=UTC date +%_H) % $1)) -eq $(($2-$1)) ] || exit 0

# Use 9 hour lag as the .anl takes really long time to appear, typically
# 6h44m.
ts=$(TZ=UTC date +%Y%m%d%H -d "-$2 hours")
td=$(TZ=UTC date +%Y%m -d "-$2 hours")
tA=$(TZ=UTC date +%Y%m%d -d "-$2 hours")
tB=$(printf "%02d" $(($(TZ=UTC date +%H -d "-$2 hours") / 6 * 6)) )

for ext in pgrb2: idx:.idx; do
	mkdir -p gdas/$td
	IFS=: read outext inext <<<"$ext"
	./get "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas.${tA}/gdas1.t${tB}z.pgrb2.1p00.anl$inext" "gdas/$td/${ts}.$outext"
	sleep 2
done
