## Install docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &&

sudo usermod -aG docker $USER


## setup repo and start services
git clone https://github.com/sgrsaga/node-react-demo.git
git checkout dev
cd node-react-demo/apps
docker compose up -d

## Install node exporter
docker run -d --name=node-exporter -p 9100:9100 prom/node-exporter

## Setup fluentd package 6
#curl -fsSL https://fluentd.cdn.cncf.io/sh/install-ubuntu-noble-fluent-package6-lts.sh | sh
docker run -d --name=fluentd -p 24224:24224 -p 24224:24224/udp \
--add-host 10e20d218886:13.234.231.159 \
-v /data:/fluentd/log \
-v /data/fluentd/etc/fluent.conf:/fluentd/etc/fluent.conf:rw \
-v /data/fluentd/plugins:/fluentd/plugins \
-v /data/fluentd/certs/http_ca.crt:/fluentd/certs/http_ca.crt:ro \
-v /var/log/fluentd:/var/log:rw \
-v /var/logs:/var/logs:rw \
fluent:v1