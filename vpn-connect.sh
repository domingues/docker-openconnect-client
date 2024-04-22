#!/bin/bash

echo $VPN_PASSWORD | openconnect \
  --protocol=$PROTOCOL \
  --disable-ipv6 \
  --script=./vpn-script-only-private-routes.sh \
  --authgroup=$AUTH_GROUP \
  --servercert=$SERVER_CERT \
  --user=$USERNAME \
  $GATEWAY
