# Setup scripts for new edge servers to sync logs and other metrics to ELK stack

## Architecture
This code is designed to be run on new servers in order to captue logging info and relay it back to the central server.
It uses [Tailscale](https://tailscale.com) to handle the management of a VPN between all of your servers. This means that you don't have to configure firewall ingress rules for your main cluster - it will not be accessible outside of the subnet.

## Usage

Before usage, fork this repository (it's useless otherwise).
Choose a domain name and edit the following files with the domain name:
- [`setup-main.sh`](./setup-main.sh)
- [`beat-configs/*.yml`](./beat-configs/) (every file - do <kbd>CTRL+F</kbd> for `k.odin.srg.id.au` and replace it)

### Setup central stack

Prerequisites:
- **IMPORTANT** - Do not allow any ingress ports in your firewall settings if you are running this on a cloud service. Since the Elasticsearch instance is only secured through the VPN, this will allow anybody to read and write to it. Tailscale will hand the port forwarding.

This will:
- Install Tailscale and prompt for authentication.
- Install Docker and `docker-compose` if you don't have it already
- Use [shaunakg/docker-elk](https://github.com/shaunakg/docker-elk) to setup an Elasticsearch + Logstash stack

Ports for running services:
- Kibana (dashboard) is on port 80
- Elasticsearch is on 9200
- Logstash is on 5000

To setup the central stack, simply run:
```
wget "https://raw.githubusercontent.com/shaunakg/elk-stack/main/setup-main.sh"
sudo sh setup-main.sh
```

After running:
- Run `tailscale ip -4` and configure your domain to point to that IP address. If you are using Cloudflare, do not proxy the DNS record.
- You should be able to connect to Kibana when you're on the Tailscale VPN, but not otherwise (the IP address should refuse to connect/not resolve). If you find that external access is possible, immediately run `sudo docker-compose down` so that you are exposed for as little time as possible.
- If you would like to capture the logs of the central server as well, then just do the steps below in addition to these.
- The password for Elasticsearch is `elastic` and `changeme` - changing this will probably require reconfiguration across all nodes.

### Setup edge node
This will:
- Install Tailscale and prompt for authentication
- Install Packetbeat, Metricbeat and Filebeat
- Configure all beats to forward data to the central logging server.
Runs on any system that uses `apt-get`, e.g Debian or Ubuntu.
```
wget "https://raw.githubusercontent.com/shaunakg/elk-stack/main/setup-node.sh"
sudo sh setup-node.sh
```

#### To configure an edge node
Configuration files are found in `/etc/*beat/*beat.yml`. When you're done editing, do `sudo service xxxx restart`, where `xxxx` is `packetbeat/metricbeat/filebeat`.


## Overview
- Current server hostname: `k.odin.srg.id.au`
- [Kibana dashboard](http://k.odin.srg.id.au) (Internal)
    - [Inventory view](http://k.odin.srg.id.au/app/metrics/inventory)
