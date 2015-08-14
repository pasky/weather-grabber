Czech Meteo Data Grabber
========================

A set of scripts to be run from crontab for building personal archive of
meteorological data.  The data is generally CC-BY-NC-ND by CHMI.

TODO: Extract numeric values from synop HTML tables and aks, milos, sonda plots.

Sample Crontab
--------------

	12,42 * * * *            (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-noaa.sh)
	6,16,26,36,46,56 * * * * (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 10m)
	7,22,37,52 * * * *       (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 15m)
	# cz uroven srazek appears at HH:14
	19 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 1h)
	# offset >1h by 1h to correct t-1h timestamps in get-maps.pl
	11 1,4,7,10,13,16,19,22 * * * (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 3h)
	# long periods are for radiosondes where data delivery is quite delayed, so use maximum offset
	13 5,11,17,23 * * *      (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 6h)
	14 5,17 * * *            (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-maps.pl 12h)
	32 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-stations-synop.sh)
	1 6 * * *                (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-stations-aks.sh)
	14 0,12 * * *            (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-wp.sh)
	38 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-eumetsat.sh)
	54 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-glofs.sh)
	57 9,21 * * *            (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./get-gdas.sh)

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
