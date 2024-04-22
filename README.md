# Docker OpenConnect VPN Client

This is a simple Docker container that runs [openconnect](https://manpages.ubuntu.com/manpages/noble/en/man8/openconnect.8.html) client.

The default gateway is removed, only private IP routes are keeped.

## Usage

Clone this repository:
```bash
git clone https://github.com/domingues/docker-openconnect-client.git
cd docker-openconnect-client
```

Create a `.env` file with your settings. For example, if you want to use Palo Alto GlobalProtect:
```bash
cat > .env <<EOF
PROTCOL=gp
AUTH_GROUP=GP-Gateway
GATEWAY=123.123.123.123
SERVER_CERT=pin-sha256:WEFHWEUIFHW983HHJWFHW89FHWEFUIOWEA8YUDS88HE=
USERNAME=username
PASSWORD=password
EOF
```

Protect your credentials:
```bash
chmod 600 .env
chown root:root .env
```

Build and run the container:
```bash
docker compose up -d --build
```
