#!/bin/bash
#
# NOAA AVHRR/3 data; bands cover red to infra spectrum, covering reflected
# sunlight as well as thermal emissions.  Also available at
# http://www.class.ngdc.noaa.gov/saa/products/detailsAVHRR but seems like
# a lot of hassle to get bulk data in good format.
#
# Usage: get-avhrr.sh

# b5 is missing from the data, but included in NM synthesis.
# RGB124 is synthesis of previous channels, so not included.
# b4BT should probably have same information as b4.

td=$(TZ=UTC date +%Y%m)

dirname=$(curl -sf http://portal.chmi.cz/files/portal/docs/meteo/sat/noaa_avhrr/ | tail -n 2 | head -n 1 | cut -d \" -f 2)
dirname=${dirname%/}
if [ -z "$dirname" ]; then
	echo "NOAA AVHRR error" >&2
	curl http://portal.chmi.cz/files/portal/docs/meteo/sat/noaa_avhrr/ >&2
	exit 1
fi

# already downloaded the last set (b4 is the only almost ubiquitious band)
[ ! -e noaa_avhrr/CE_b4/${dirname}.jpg ] || exit 0

for i in b1 b2 b3 b4 NM; do
	mkdir -p noaa_avhrr/CE_$i/$td
	./get "http://portal.chmi.cz/files/portal/docs/meteo/sat/noaa_avhrr/$dirname/${dirname}_CE_${i}.jpg" "noaa_avhrr/CE_$i/$td/$dirname.jpg" >/dev/null
	# ignore wget errors, many channels are often missing
	sleep 2
done
