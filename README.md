Czech Meteo Data Grabber
========================

A set of scripts to be run from crontab for building personal archive of
meteorological data.  The data is generally CC-BY-NC-ND by CHMI.

TODO: Extract numeric values from synop HTML tables and aks, milos, sonda plots.

Sample Crontab
--------------

	12,42 * * * *            (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-noaa.sh)

	6,16,26,36,46,56 * * * * (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 10m 0)
	7,22,37,52 * * * *       (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 15m 0)
	19 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 1h 0)
	11 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 3h 1)  # every 3h, +1hour ofs
	# long periods are for radiosondes where data delivery is quite delayed
	13 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 6h 5)  # every 6h, +5hours ofs
	14 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 12h 5)  # every 12h, +5hours ofs

	32 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-stations-synop.sh)
	1 * * * *                (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-stations-aks.sh 6 0)  # every 6 hours
	14 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-wp.sh 12 0)  # every 12 hours
	38 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-eumetsat.sh)
	54 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-glofs.sh)
	57 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-gdas.sh 12 9)  # every 12 hours, +9hours ofs

Note that we call even scripts that should run just once per several hours
every hour, and we verify whether it's time to run within the script.  This
is so that our hour offsets for these scripts are stably in UTC, since it's
not easy to portably use UTC in crontabs, unfortunately.

Format Notes
------------

### Sondy

Grafy "PTU+vítr":
  * Teplota (červená čára )
  * Teplota rosného bodu (modrá čára )
  * Suchá adiabata (oranžová čára )
  * Nasycená adiabata (zelená čára )
  * Směšovací poměr (žlutá čára )
  * VKH ( °C, hPa) = Výstupná kondenzační hladina
  * KKH ( °C, hPa) = Konvekční kondenzační hladina
  * Faust = index stability; lt 0 žádná význačná aktivita; 0 až 3   lze očekávat přeháňky; gt 3   lze očekávat bouřky
  * Tkonv (°C) = Konvekční teplota
  * Význačné hladiny větru (deg / ms-1) jsou vyznačeny na pravém okraji grafu.

"Graf vítr":
  * Rychlost větru (červená čára )
  * Směr větru (modré body )

Additional Resources
--------------------

  * Very nicely cleaned up historical data for global stations across the world,
    hourly frequency: ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-lite

  * Web API for historical METAR/ASOS/AWOS data with hourly or even sub-hourly
    resolution: http://mesonet.agron.iastate.edu/request/download.phtml
