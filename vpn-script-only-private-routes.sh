#!/bin/bash

export INTERNAL_IP4_DNS=

del_network_route() {
	NETWORK="$1"
	NETMASK="$2"
	NETMASKLEN="$3"
	NETDEV="$4"
	echo "ip route del \"$NETWORK/$NETMASKLEN\" dev \"$NETDEV\""
	ip route del "$NETWORK/$NETMASKLEN" dev "$NETDEV"
	ip route flush cache 2>/dev/null
}

cleanup_routes() {
	if [ -n "$CISCO_SPLIT_INC" ]; then
		i=0
		while [ $i -lt $CISCO_SPLIT_INC ] ; do
			eval NETWORK="\${CISCO_SPLIT_INC_${i}_ADDR}"
			eval NETMASK="\${CISCO_SPLIT_INC_${i}_MASK}"
			eval NETMASKLEN="\${CISCO_SPLIT_INC_${i}_MASKLEN}"
			# Check if the IP address is NOT within one of the private address ranges
			if ! [[ "$NETWORK" =~ ^10\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.|^192\.168\. ]]; then
				del_network_route "$NETWORK" "$NETMASK" "$NETMASKLEN" "$TUNDEV"
			fi
			i=`expr $i + 1`
		done
		for i in $INTERNAL_IP4_DNS ; do
			del_network_route "$i" "255.255.255.255" "32" "$TUNDEV"
		done
	fi
	# Remove default route
	ip route del default dev "$NETDEV"
	ip route flush cache 2>/dev/null
}


if [ -z "$reason" ]; then
	echo "this script must be called from vpnc" 1>&2
	exit 1
fi

/usr/share/vpnc-scripts/vpnc-script

case "$reason" in
	pre-init)
		;;
	connect)
		cleanup_routes
		;;
	disconnect)
		;;
	attempt-reconnect)
		;;
	reconnect)
		;;
	*)
		echo "unknown reason '$reason'. Maybe vpnc-script is out of date" 1>&2
		exit 1
		;;
esac

exit 0
