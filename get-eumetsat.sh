#!/bin/bash
# Get eumetsat MSG (Meteosat) central european channels.
# ./get-eumetsat.sh
# Updated hourly, but sometimes an update is missed.

ts=$(TZ=UTC date +%Y%m%d%H)
td=$(TZ=UTC date +%Y%m)

# http://oiswww.eumetsat.org/IPPS/html/latestImages.html
for ch in IR039 IR108 VIS006 WV062; do
	dir="eumetsat_MSG_CE/$ch/$td"
	mkdir -p "$dir"
	lastfile=$(ls "$dir" | tail -n1)

	wget -q -O "$dir/${ts}.jpg" "http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_${ch}E-centralEurope.jpg"
	wgetstatus=$?
	if [ $wgetstatus -ne 0 ]; then
		echo "wget http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_${ch}E-centralEurope.jpg failed $wgetstatus" >&2
	fi

	if [ -n "$lastfile" -a "$lastfile" != "${ts}.jpg" ]; then
		# Check that we didn't fetch a duplicate
		lsum=$(md5sum "$dir/$lastfile" | awk '{print$1}')
		nsum=$(md5sum "$dir/${ts}.jpg" | awk '{print$1}')
		if [ "$lsum" = "$nsum" ]; then
			rm "$dir/${ts}.jpg"
		fi
	fi

	sleep 2
done
