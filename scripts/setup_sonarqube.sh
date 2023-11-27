#!/bin/bash

SSH_USERNAME=$1
SSH_PASSWORD=$2
ADMIN_PASSWORD=$3
DATABASE_HOST=$4
DATABASE_PORT=$5
DATABASE_NAME=$6
DATABASE_USERNAME=$7
DATABASE_PASSWORD=$8
DOMAIN_NAME=$9

# Update the system
sudo apt-get update

# Install the necessary properties
sudo apt-get install -y wget ca-certificates docker.io nginx

# Import the repository key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Add the PostgreSQL repository to your system
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

# Update and install necessary packages
sudo apt update
sudo apt-get install -y postgresql-client

# Verify the installation
echo "PostgreSQL client version:"
psql --version

# Add user and assign privileges
sudo useradd -m -s /bin/bash $SSH_USERNAME
echo $SSH_USERNAME:$SSH_PASSWORD | sudo chpasswd
sudo usermod -aG sudo $SSH_USERNAME
sudo usermod -aG docker $SSH_USERNAME

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Set system limits
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192

# Create Docker volumes
docker volume create --name sonarqube_data
docker volume create --name sonarqube_logs
docker volume create --name sonarqube_extensions

# Run SonarQube Docker container
docker run -d --name sonarqube -p 9000:9000 \
    -e SONAR_JDBC_URL="jdbc:postgresql://$DATABASE_HOST:$DATABASE_PORT/$DATABASE_NAME" \
    -e SONAR_JDBC_USERNAME="$DATABASE_USERNAME" \
    -e SONAR_JDBC_PASSWORD="$DATABASE_PASSWORD" \
    -v sonarqube_data:/opt/sonarqube/data \
    -v sonarqube_extensions:/opt/sonarqube/extensions \
    -v sonarqube_logs:/opt/sonarqube/logs sonarqube:latest

# Configure Nginx for reverse proxy with SSL
sudo tee /etc/nginx/sites-available/sonarqube <<EOF
server {
    listen 80;
    server_name $DOMAIN_NAME;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl;
    server_name $DOMAIN_NAME;

    ssl_certificate /etc/ssl/certs/tls.crt;
    ssl_certificate_key /etc/ssl/private/tls.pem;

    location / {
        proxy_pass http://localhost:9000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable the configuration and restart Nginx
sudo ln -s /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Check running containers
docker ps -a

# Wait for SonarQube to be fully operational
while ! curl -s http://localhost:9000/api/system/status | grep -q '"status":"UP"'; do
    echo "Waiting for SonarQube to be fully operational..."
    sleep 10
done

# Set sonar.core.serverBaseURL via SonarQube Web API using default admin credentials
curl -u admin:admin -X POST "http://localhost:9000/api/settings/set?key=sonar.core.serverBaseURL&value=https://$DOMAIN_NAME"

# Reset SonarQube admin password via SonarQube Web API using default admin credentials
curl -u admin:admin -X POST "http://localhost:9000/api/users/change_password?login=admin&password=$ADMIN_PASSWORD&previousPassword=admin"

# Restart SonarQube
docker restart sonarqube