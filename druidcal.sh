#!/bin/bash
## Druid calendar
## Gives today's date in terms of the Reform's Druidic Calendar
## Wraidd, 1 May 2018 (Beltaine 56)
## Todo:
## - Modify to change to "next day" around 6 pm
## - Make DoW-eve and DoW-day

DEBUG=false

# Initial variables

DOWNAME=( 'Oak' 'Aspen' 'Maple' 'Rowan' 'Pine' 'Olive' 'Birch' )

[ $# -eq 0 ] && INDATE=$(date) || INDATE=$(date -d "$@")

NOW=$(date -d "$INDATE" +"%s") 			# evaluate this date
YEAR=$(date -d "$INDATE" +"%Y")			# year
XOVER=$(date -d "May 1 $YEAR" +"%s")	# Is it before or after 1 May?
DOWNUM=$(date -d "$INDATE" +"%w")		# What day of the week is it
CMONTH=$(date -d "$INDATE" +"%m")		# What month is it
DAY=$(date -d "$INDATE" +"%d")			# What day is it
DAY=$((10#$DAY)) 						# Force base-10/trash leading 0

# Is the given year a leap year?

[[ $(date -d "yesterday 3/1/$YEAR" +"%d") -eq 29 ]] && LY=true || LY=false

if [[ $NOW -gt $XOVER ]];
then
	YEAR=$((YEAR-1962))
else
	YEAR=$((YEAR-1963))
fi

$DEBUG && printf "Year: %s\n" $YEAR

$DEBUG && printf "Today: %s/%s\n" $DAY $CMONTH

# Parse month and day

case $CMONTH in
	"05")
		[ $DAY == 1 ] && TODAY="Beltaine"
		DMONTH="Samradh"
		;;
	"06")
		DMONTH="Samradh"
		DAY=$(( DAY+31 ))
		;;
	"07")
		DMONTH="Samradh"
		DAY=$(( DAY+61 ))
		;;
	"08")
		[ $DAY == 1 ] && TODAY="Lughnasadh"
		DMONTH="Foghamhar"
		;;
	"09")
		DMONTH="Foghamhar"
		DAY=$(( DAY+31 ))
		;;
	"10")
		DMONTH="Foghamhar"
		DAY=$(( DAY+61 ))
		;;
	"11")
		[ $DAY == 1 ] && TODAY="Samhain"
		DMONTH="Geimredh"
		;;
	"12")
		DMONTH="Geimredh"
		DAY=$(( DAY+30 ))
		;;
	"01")
		DMONTH="Geimredh"
		DAY=$(( DAY+61 ))
		;;
	"02")
		[ $DAY == 1 ] && TODAY="Oimelc"
		DMONTH="Earrach"
		;;
	"03")
		DMONTH="Earrach"
		$LY && DAY=$(( DAY+29 )) || DAY=$(( DAY+28 ))
		;;
	"04")
		DMONTH="Earrach"
		$LY && DAY=$(( DAY+60 )) || DAY=$(( DAY+59 ))
		;;
	*)
		printf "Oops, something went wrong.\n";
		exit
		;;
esac

# If it's a special day, i.e. if TODAY is defined, don't use standard date

[ -z $TODAY ] && TODAY="$DAY $DMONTH"

# Output date

printf "%sday, %s, YR %s\n" "${DOWNAME[$DOWNUM]}" "$TODAY" $YEAR
