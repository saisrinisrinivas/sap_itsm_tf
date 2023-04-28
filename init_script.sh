#!/bin/sh
sudo apt update &&
sudo apt upgrade -y &&
sudo apt install -y curl &&
curl -fsSL https://get.docker.com -o get-docker.sh &&
chmod +x get-docker.sh &&
sudo ./get-docker.sh &&
sudo usermod -aG docker azureuser &&
sudo apt install docker-compose -y &&
sudo docker volume create --name jiraVolume &&
sudo docker run -v jiraVolume:/var/atlassian/application-data/jira --name="jira" -d -p 9000:8080 atlassian/jira-software &&
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - &&
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list &&
sudo apt update &&
sudo apt install elasticsearch &&
sudo apt start elasticsearch &&
sudo apt enable elasticsearch &&
sudo apt install kibana &&
sudo apt enable kibana &&
sudo apt install nginx &&
sudo apt update &&
sudo apt install apt-transport-https ca-certificates curl software-properties-common

