#!/bin/bash
# Get METARS/MARINE *global* observation summaries.
# ./get-glofs.sh
# Updated once an hour.
#
# These summaries are in the BUFR format, not terribly convenient
# to work with:
# 	http://www.nco.ncep.noaa.gov/pmb/codes/nwprod/glofs.v1.0.1/sorc/glofs_marobs.fd/glofs_marobs.f
# Moreover, they were made for consumption by a specific forecast
# system GLOFS, so they might go away sometime...
# However, they are the nicest hourly summaries I have found (esp.
# including buoy data), for some alternatives see the README.

ts=$(TZ=UTC date +%Y%m%d%H)
td=$(TZ=UTC date +%Y%m)
tA=$(TZ=UTC date +%Y%m%d)
tB=$(TZ=UTC date +%H)

for c in metars marine; do
	mkdir -p glofs/$c/$td
	./get -z "http://www.ftp.ncep.noaa.gov/data/nccf/com/hourly/prod/hourly.${tA}/glofs.t${tB}z.${c}.bufr_d.unblk" "glofs/$c/$td/${ts}.bufr_d.unblk"
	sleep 2
done
