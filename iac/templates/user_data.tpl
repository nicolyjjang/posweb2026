#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Instalação de dependências e configuração do ambiente
apt update -y

apt -y install \
    net-tools \
    mysql-server \
    python3-pip \
    python3-venv \
    pkg-config \
    default-libmysqlclient-dev \
    nginx

# Configuração do ambiente python
echo "Configurando ambiente Python..."
mkdir /home/ubuntu/myapp
cd /home/ubuntu/myapp
python3 -m venv .
source ./bin/activate
pip install \
    flask \
    flask-mysqldb \
    flask-cors

chown -R ubuntu:ubuntu /home/ubuntu/myapp # Garante que o usuário ubuntu tenha acesso à pasta da aplicação.

# Configuração do Systemd para a API Flask
echo "Configurando Systemd..."
cat > /etc/systemd/system/myapp.service <<SERVICE
[Unit]
Description=MyApp Flask API
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/myapp
ExecStart=/home/ubuntu/myapp/bin/python /home/ubuntu/myapp/myapi.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable myapp

# Nginx 
echo "Configurando Nginx..."
cat > /etc/nginx/sites-available/default <<NGINX
server {
    listen 80;
    server_name _;

    root /var/www/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
NGINX

nginx -t
systemctl restart nginx

# Prepara diretórios para o Github Actions
echo "Preparando diretórios para o Github Actions..."
mkdir -p /home/ubuntu/.ssh
chown -R ubuntu:ubuntu /var/www/html 
chown -R ubuntu:ubuntu /home/ubuntu/myapp

echo "Configuração concluída!"