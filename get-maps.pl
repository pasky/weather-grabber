#!/usr/bin/perl
# Get meteorological maps.
# Usage: get-maps.pl {10m,15m,1h,3h,6h,12h}
# Run from an appropriate crontab entry.

use warnings;
use strict;
use v5.16;

my %resources = (
	"cz srazkradar" => ["http://www.chmi.cz/files/portal/docs/meteo/rad/inca-cz/data/czrad-z_max3d/pacz2gmaps3.z_max3d.YYYYMMDD.HHmm.0.png", "10m", ''],
	"cz srazkradar fixh" => ["http://www.chmi.cz/files/portal/docs/meteo/rad/inca-cz/data/czrad-z_cappi020/pacz2gmaps3.z_cappi020.YYYYMMDD.HHmm.0.png", "10m", ''],
	"cz blesky" => ["http://www.chmi.cz/files/portal/docs/meteo/rad/inca-cz/data/celdn/pacz2gmaps3.blesk.YYYYMMDD.HHmm.png", "10m", ''],
	"cz synop" => ["http://www.chmi.cz/files/portal/docs/meteo/rad/inca-cz/data/synop/pacz2gmaps9.synop.YYYYMMDD.HHmm.0.png", "1h", ''],
	"ce srazky" => ["http://www.inca-ce.eu/CE-Portal/data/prec1h/ZAMG.RR_1h.YYYYMMDD.HHmm.1.png", "1h", ''],
	"ce wind" => ["http://www.inca-ce.eu/CE-Portal/data/wind/INCA.UV.YYYYMMDD.HHmm.1h.png", "1h", ''],
	"ce gust" => ["http://www.inca-ce.eu/CE-Portal/data/gust/INCA.UVG.YYYYMMDD.HHmm.1h.png", "1h", ''],
	"ce teplota" => ["http://www.inca-ce.eu/CE-Portal/data/temp/INCA.T2M.YYYYMMDD.HHmm.1h.png", "1h", ''],
	"eu teplota-sym" => ["http://portal.chmi.cz/files/portal/docs/meteo/om/evropa/T2m_evropa.gif", "3h", 'httpts'],
	"eu synoptic" => ["http://portal.chmi.cz/files/portal/docs/meteo/om/evropa/analyza.gif", "3h", 'httpts'],
	"cz srazkradar 1km" => ["http://www.chmi.cz/files/portal/docs/meteo/rad/data_tr_png_1km/pacz23.z_max3d.YYYYMMDD.HHmm.0.png", "15m", ''],
	"msg ce ir" => ["http://www.chmi.cz/files/portal/docs/meteo/sat/msg_hrit/img-msgce-ir/msgce.ir.YYYYMMDD.HHmm.0.jpg", "15m", ''],
	"cz teplota" => ["http://portal.chmi.cz/files/portal/docs/poboc/OS/OMK/mapy/T.png", "1h", 'httpts'],
	# XXX: Having this among "maps" is a bit of a hack
	"sonda praha 500" => ["http://portal.chmi.cz/files/portal/docs/meteo/oa/data_sondaz/dsd500.gif", "6h", ''],
	"sonda praha wind" => ["http://portal.chmi.cz/files/portal/docs/meteo/oa/data_sondaz/dsd_wind.gif", "6h", ''],
	"sonda prostejov 500" => ["http://portal.chmi.cz/files/portal/docs/meteo/oa/data_sondaz_prostejov/dsd500.gif", "12h", ''],
	"sonda prostejov wind" => ["http://portal.chmi.cz/files/portal/docs/meteo/oa/data_sondaz_prostejov/dsd_wind.gif", "12h", ''],
	"milos libus" => ["http://portal.chmi.cz/files/portal/docs/meteo/oa/data_milos/milos.png", "10m", 'httpts'],
);

# Get directory name by period; longer periods mean lower granularity
# of storage.
sub get_period_td {
	my ($period, $year, $mon, $mday) = @_;
	if ($period =~ /m$/) {
		return $year.$mon.$mday;
	} elsif ($period =~ /[0-4]h$/) {
		return $year.$mon;
	} else {
		return $year;
	}
}

# Get the given time in split form, also rounded down to last period boundary.
sub get_split_time {
	my ($period, $t) = @_;

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($t);
	$year += 1900;
	$mon = sprintf('%02d', $mon+1);
	$mday = sprintf('%02d', $mday);
	if ($period =~ /(\d+)h$/) {
		$hour = int($hour/$1) * $1;
	}
	$hour = sprintf('%02d', $hour);
	if ($period =~ /(\d+)m$/) {
		$min = int($min/$1) * $1;
	} else {
		$min = 0;
	}
	$min = sprintf('%02d', $min);

	return ($min, $hour, $mday, $mon, $year);
}

my ($period, $hourofs) = @ARGV;

my ($min, $hour, $mday, $mon, $year) = get_split_time($period, time - $hourofs*3600);

# With periods >1h, verify that we are called at the right hour.
if ($period =~ /(\d+)h$/ and $1 > 1) {
	exit() unless ($hour % $1) == 0;
}

foreach my $r (keys %resources) {
	my ($url, $per, $flags) = @{$resources{$r}};
	next unless $per eq $period;

	$url =~ s/YYYY/$year/g;
	$url =~ s/MM/$mon/g;
	$url =~ s/DD/$mday/g;
	$url =~ s/HH/$hour/g;
	$url =~ s/mm/$min/g;
	my ($ext) = ($url =~ /.*\.(.*)/);

	my ($r_year, $r_mon, $r_mday, $r_hour, $r_min);
	if ($flags =~ /httpts/) {
		# Instead of reference time, look at the last-modified
		# HTTP header to determine when was the given file generated;
		# this is useful when there is no timestamp in filename.
		# It takes some time to generate file for a given time, so we
		# of course still round that time to period boundary.
		my $t = `date -d "\$(curl -sf -I "$url" | grep '^Last-Modified' | cut -d: -f2,3,4)" +%s`;
		($r_min, $r_hour, $r_mday, $r_mon, $r_year) = get_split_time($period, $t);
	} else {
		($r_min, $r_hour, $r_mday, $r_mon, $r_year) = ($min, $hour, $mday, $mon, $year);
	}

	my $ts = $year.$mon.$mday.$hour.$min;
	my $td = get_period_td($per, $year, $mon, $mday);

	# just to be sure
	mkdir("maps/$r");
	mkdir("maps/$r/$td");

	system('wget', '-q', '-O', "maps/$r/$td/$ts.$ext", $url);
	if ($flags !~ /failok/ and $? != 0) {
		say STDERR "$url: wget returned status $?";
	}
	sleep(2);
}
