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
sudo apt update &&
sudo apt install nginx &&
sudo systemctl enable nginx &&
sudo systemctl start nginx &&
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - &&
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list &&
sudo apt update &&
sudo apt install elasticsearch &&
sudo systemctl start elasticsearch &&
sudo systemctl enable elasticsearch &&
sudo apt install kibana &&
sudo systemctl enable kibana &&
sudo systemctl start kibana &&
sudo apt install nodejs &&
sudo apt install npm


