## This sets up the primary Elasticsearch + Logstash cluster.
# This installs:
#   - Tailscale (+ sets it up)
#   - Docker
#   - Docker Compose

# Server base URL with NO TRAILING SLASH
SERVER_BASEURL="http://bayou.ars.gg/"

curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale
sudo tailscale up

sudo apt-get install python3-pip
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo pip3 install docker-compose

git clone https://github.com/deviantony/docker-elk
cd docker-elk

printf "\nserver.publicBaseUrl: \"$SERVER_BASEURL\"\n" >> ./kibana/config/kibana.yml

sudo docker-compose up -d

printf "\nServices have now started. Use \"sudo docker-compose logs --follow\" to see logs.\n"
