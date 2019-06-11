#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Usage: <output file> <input config>"
	exit 1
fi

if [ ! -f "$2" ]; then
	echo "Usage: <output file> <input config>"
	exit 1
fi
	
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

if [ ! -f "$1" ]; then
	touch "$1"
fi

echo "" > $1

function get_dev_str {
	_GEN_NAME_RC=1

	USB_BUS_ID="0003" # linux usb bus should always be 0x0003

	vendor_kvp=`echo "$1" | grep --color=never "ID_VENDOR="`
	if [ "$?" == "1" ]; then
		vendor_id="none"
	else
		vendor_id=${vendor_kvp##*=}
		vendor_id=${vendor_id^^}
	fi
 
	model_kvp=`echo "$1" | grep --color=never "ID_MODEL_ID="`
	if [ "$?" == "1" ]; then
		model_id="none"
	else
		model_id=${model_kvp##*=}
		model_id=${model_id^^}
	fi

	_GEN_NAME_RC=0
	echo "evdev:input:b${USB_BUS_ID}v${vendor_id}p${model_id}e*"
}

echo "Searching for devices..."

input_devices=($(ls /dev/input/event*))

echo "Found ${#input_devices[@]} input devices"

for i_dev in "${input_devices[@]}"
do
	dev_properties=`udevadm info $i_dev`
	if echo "$dev_properties" | grep -qc "ID_INPUT_KEYBOARD=1"; then
		if echo "$dev_properties" | grep -qc "ID_BUS=usb"; then
			echo "$i_dev is USB a keyboard!"
			CONFIG_HDR=`get_dev_str "$dev_properties"`
			echo "$CONFIG_HDR" >> $1 
			cat $2 >> $1
			echo -e "\n" >> $1
		fi
	fi
done
