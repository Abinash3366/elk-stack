#!/bin/bash

echo "========================================================="
echo "Setting up edge node for logging and network monitoring."
echo "========================================================="

echo "[INFO] Installing Tailscale"
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list

sudo apt-get update
sudo apt-get install tailscale

echo "[INFO] Tailscale is installed. It will be set up later."
echo "[INFO] Installing beats"

mkdir beats
cd beats

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install packetbeat filebeat metricbeat -y

# Setup filebeat
curl -L "https://raw.githubusercontent.com/shaunakg/elk-stack/main/beat-configs/filebeat.yml" | sudo tee /etc/filebeat/filebeat.yml

# Setup metricbeat
curl -L "https://raw.githubusercontent.com/shaunakg/elk-stack/main/beat-configs/metricbeat.yml" | sudo tee /etc/metricbeat/metricbeat.yml

# Setup packetbeat
curl -L "https://raw.githubusercontent.com/shaunakg/elk-stack/main/beat-configs/packetbeat.yml" | sudo tee /etc/packetbeat/packetbeat.yml

echo "[INFO] Installation complete."

echo "[INFO] Authorizing Tailscale before starting beats."
echo "[INFO] If you didn't include an authkey as the first argument, you now need to authorize your Tailscale account manually."
sudo tailscale up --authkey "$1"

echo "[INFO] Starting all beats"

sudo service filebeat restart && echo "[INFO] Filebeat started"
sudo service metricbeat restart && echo "[INFO] Metricbeat started"
sudo service packetbeat restart && echo "[INFO] Packetbeat started"

echo "[INFO] Done. For next steps, visit https://github.com/shaunakg/elk-stack"
