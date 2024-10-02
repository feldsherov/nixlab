#!/bin/sh

BATTERY_DIR="/sys/class/power_supply/BAT1/"

common() {
echo -n "{"
echo -n "\"separator_block_width\":0,"
echo -n "\"color\":\"#000000\","
echo -n "\"background\":\"$bg\","
echo -n "\"name\":\"$name\","
echo -n "\"full_text\":\" $stat\","
echo -n "},"
}

battery0() {
local bg="#D69E2E"
local name="battery"
prct=$(cat ${BATTERY_DIR}/capacity)
chrg=$(cat ${BATTERY_DIR}/status)
local stat=${chrg}/${prct}" "
common
}

mydate() {
local bg="#E0E0E0"
local name="id_time"
local stat=$(date "+%a-%b-%d %H:%M ") 
common
}


echo '{ "version": 1 , "click_events":false}'
echo '[[],'

while :
do
echo -n "["
battery0
mydate
echo -n "],"
sleep 1
done


