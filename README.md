# P1 Omega2

This is a hobby project for the [Onion Omega2](https://onion.io/omega2/) device. The Omega2 is a tiny [$7.5](https://onion.io/store/omega2/) IoT computer with WiFi support. This project uses the Omega2 to read the energy readings from a P1 port of a Dutch Smart Energy Meter ("slimme energiemeter"), and displays the values on the OLED display, as well as uploads the data to [PVOutput](https://pvoutput.org/).

## Requirements

 - Dutch Smart Energy Reader that supports DSMR protocol version 5
 - Omega2 with an [expansion dock](https://onion.io/store/expansion-dock/) or [mini dock](https://onion.io/store/mini-dock/)
 - [OLED expansion](https://onion.io/store/oled-expansion/) if you want to display values (optional)
 - P1 converter cable to the Smart Energy Meter, for example [this one](https://sites.google.com/site/nta8130p1smartmeter/webshop) or [this one](https://www.sossolutions.nl/slimme-meter-kabel)
 - [PVOutput API key](https://pvoutput.org/account.jsp)

## Instructions

 - Install necessary tools:
    `opkg install bash screen bc oled-exp`
 - Edit your crontab:
    `crontab -e`
    Add the line:
    `@reboot /path/to/p1.sh PVOUTPUT-API-KEY`
