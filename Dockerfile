FROM ubuntu:24.04

RUN apt-get -y update &&  \ 
    apt-get install --no-install-recommends -y \
    	openconnect \
    && rm -rf /var/lib/apt/lists/*

COPY vpn-connect.sh vpn-script-only-private-routes.sh /

CMD ["/vpn-connect.sh"]
