#!/bin/bash

# DSMR version 5 monitoring
# Spec: https://www.netbeheernederland.nl/_upload/Files/Slimme_meter_15_a727fce1f1.pdf

screen -dm /dev/ttyUSB0 115200 # Set baudrate on serial port (stty not included in Omega2)
killall screen # Immediate kill screen
oled-exp -i # Init the OLED screen
shopt -s extglob # Turn on extended globbing

DATA=() # Array of lines
PARSED=() # Parsed data

get_val () {
  [[ $1 =~ \(([0-9.]+).*\) ]] && echo "${BASH_REMATCH[1]}"
}

while read line; do
  if [[ $line == /XMX* ]]; then # Header line
    for l in "${DATA[@]}"; do
      val=$(get_val $l)
      case $l in
        1-3:0.2.8*)
          echo "Version: $val";;
        1-0:1.8.1*)
          PARSED+=($val)
          echo "Energy used (low tariff): $val";;
        1-0:1.8.2*)
          PARSED+=($val)
          echo "Energy used (high tariff): $val";;
        1-0:2.8.1*)
          PARSED+=($val)
          echo "Energy delivered (low tariff): $val";;
        1-0:2.8.2*)
          PARSED+=($val)
          echo "Energy delivered (high tariff): $val";;
        0-0:96.14.0*)
          PARSED+=($val)
          echo "Current tariff: $val";;
        1-0:21.7.0*)
          PARSED+=($val)
          echo "Instantaneous active power L1 (+P): $val W";;
        1-0:41.7.0*)
          PARSED+=($val)
          echo "Instantaneous active power L2 (+P): $val W";;
        1-0:61.7.0*)
          PARSED+=($val)
          echo "Instantaneous active power L3 (+P): $val W";;
        1-0:22.7.0*)
          PARSED+=($val)
          echo "Instantaneous active power L1 (-P): $val W";;
        1-0:42.7.0*)
          PARSED+=($val)
          echo "Instantaneous active power L2 (-P): $val W";;
        1-0:62.7.0*)
          PARSED+=($val)
          echo "Instantaneous active power L3 (-P): $val W";;
        *)
#          echo "$l"
      esac
    done

    act_plus=$(echo "(${PARSED[5]} + ${PARSED[6]} + ${PARSED[7]}) * 1000 / 1" | bc)
    act_min=$(echo "(${PARSED[8]} + ${PARSED[9]} + ${PARSED[10]}) * 1000 / 1" | bc)
    oled-exp cursor 0,0 write "Energy used (kWh):\n${PARSED[0]##*(0)} + ${PARSED[1]##*(0)}\n\nEnergy delivered:\n${PARSED[2]##*(0)} + ${PARSED[3]##*(0)}\n\nPower +P: $act_plus W\nPower -P: $act_min W"

    DATA=() # Clear array
    PARSED=() # This one too
  else
    DATA+=($line) # Add line to array
  fi
done < /dev/ttyUSB0
