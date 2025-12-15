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

## start prometheus
mkdir prometheus

cat <<EOF > prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "my-server"
    static_configs:
      - targets:
          - "13.234.231.159:9100"
        labels:
          host: node-react-monitoring-1
          type: monitor
      - targets:
          - "52.66.168.202:9100"
        labels:
          host: node-react-apps-1
          type: app
EOF

touch prometheus/prometheus.yml
docker run -d --rm \
    --name=prometheus \
    -p 9090:9090 \
    -v /home/ubuntu/prometheus:/etc/prometheus \
    prom/prometheus

## start grafana
docker run -d --rm -p 3000:3000 --name=grafana grafana/grafana-enterprise

## Install node exporter
docker run -d --rm --name=node-exporter -p 9100:9100 prom/node-exporter

## setup elastic search
docker network create elastic
docker run --name es01 --net elastic -p 9200:9200 -it -m 1GB docker.elastic.co/elasticsearch/elasticsearch:9.2.2

## generate tokens
#docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic
#docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana

## setup kibana
docker run --name kib01 --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:9.2.2
