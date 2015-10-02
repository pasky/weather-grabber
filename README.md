Czech Meteo Data Grabber
========================

A set of scripts to be run from crontab for building personal archive of
meteorological data.  The data is generally CC-BY-NC-ND by CHMI.

TODO: Extract numeric values from synop HTML tables and aks, milos, sonda plots.

Sample Crontab
--------------

	12,42 * * * *            (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-noaa.sh)

	# use +1h offset in general to ensure there's time to propagate data
	6,16,26,36,46,56 * * * * (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-maps.pl 10m 1)
	7,22,37,52 * * * *       (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-maps.pl 15m 1)
	19 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-maps.pl 1h 1)
	11 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-maps.pl 3h 1)  # every 3h, in fact
	13 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-maps.pl 6h 1)  # every 6h, in fact
	14 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-maps.pl 12h 1)  # every 12h, in fact

	32 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-stations-synop.sh)
	1 * * * *                (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-stations-aks.sh 24 4)  # every 24 hours, at 4:00 UTC
	14 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-wp.sh 12 0)  # every 12 hours
	38 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-eumetsat.sh)
	54 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-glofs.sh)
	# +9hour offset as it typically takes 6h44m to publish the .anl file
	57 * * * *               (cd /home/pasky/src/meteo/weather-grabber; nice -n 19 ./log ./get-gdas.sh 6 9)  # every 6 hours

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

  * Tables of selected variables from CHMI professional stations:
    http://pr-asv.chmi.cz/synopy-tab/

  * Hydrological tables: http://hydro.chmi.cz/hpps/hpps_act_rain.php
