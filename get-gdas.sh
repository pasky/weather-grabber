#!/bin/bash
# Get GDAS *global* observation summaries.
# ./get-gdas.sh
# Updated every six hours.
#
# Global Data Acquisition System integrates data from a huge number
# of world-wide sources to build a grid of various variables:
#	https://ready.arl.noaa.gov/gdas1.php
# We grab the 1-degree grid resolution.

# Use 9 hour lag as the .anl takes really long time to appear, typically
# 6h44m.
ts=$(TZ=UTC date +%Y%m%d%H -d '-9 hours')
td=$(TZ=UTC date +%Y%m -d '-9 hours')
tA=$(TZ=UTC date +%Y%m%d -d '-9 hours')
tB=$(printf "%02d" $(($(TZ=UTC date +%H -d '-9 hours') / 6 * 6)) )

for ext in pgrb2: idx:.idx; do
	mkdir -p gdas/$td
	IFS=: read outext inext <<<"$ext"
	wget -q -O "gdas/$td/${ts}.$outext" "http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas.${tA}/gdas1.t${tB}z.pgrb2.1p00.anl$inext"
	wgetstatus=$?
	if [ $wgetstatus -ne 0 ]; then
		echo "wget http://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gdas.${tA}/gdas1.t${tB}z.pgrb2.1p00.anl$inext failed $wgetstatus" >&2
	fi
	sleep 2
done
