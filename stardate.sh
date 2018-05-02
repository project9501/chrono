#!/bin/bash
# General function outline
# - Test if it is before or after 15 July
# - We do this by the following:
## NOW=date
## JUL=date -d "july 15"
## if NOW >= JUL then use next july as the "end"
## Else proceed as normal

DEBUG=false

NOW=$(date +"%s")
JUL=$(date -d "july 15" +"%s")

if [[ $NOW -ge $JUL ]] # In other words, if it's after July 15
then                   # then we want to use next July as our xx999
	THISYEAR=$(date +"%Y")
	NEXTYEAR=$(( THISYEAR+1 ))
else				   # Otherwise this July is fine as our xx999
	NEXTYEAR=$(date +"%Y")
	THISYEAR=$(( NEXTYEAR-1 ))
fi

$DEBUG && printf "%s %s" $THISYEAR $NEXTYEAR

TTIME=$(date -d "$THISYEAR-07-15 00:00:00+0" +"%s") # start point
NTIME=$(date -d "$NEXTYEAR-07-15 00:00:00+0" +"%s") # end point
NOW=$(date +"%s") 									# now

NOW=$(( NOW-TTIME ))
NOW=$(( NOW*1000 )) # because it's PPSSS.SSS, where SSS.SSS is a "out of 1000" ratio
TOT=$(( NTIME-TTIME )) # our total interval, gonna be 31mil usually but a bit more on leap years

PREFIX=$(( THISYEAR-1987 )) # epoch, adjust this for different standards
PREFIX=$(( PREFIX+41 )) # also epoch, 1987-07-15=SD41000

SUFFIX=$(echo "scale=3;$NOW/$TOT" | bc) # bit of a kludge

$DEBUG && printf "THISYEAR: %d\n \
				NEXTYEAR: %d\n \
				TTIME: %d\n \
				NTIME: %d\n \
				NOW: %d\n \
				TOT: %d\n \
				PREFIX: %d\n \
				SUFFIX: %f\n" \
				$THISYEAR $NEXTYEAR $TTIME $NTIME $NOW $TOT $PREFIX $SUFFIX

printf "%d%.3f" $PREFIX $SUFFIX
