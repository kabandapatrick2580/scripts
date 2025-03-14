#!/bin/bash

# This script installs Nginx, PHP (selectable version), and configures PHP-FPM for Nginx on Ubuntu/Debian.

# Define the PHP version you want to install (Change this if needed)
PHP_VERSION="8.1"

# Update system packages
echo "Updating package lists..."
sudo apt update -y && sudo apt upgrade -y

# Install necessary dependencies
echo "Installing required dependencies..."
sudo apt install -y software-properties-common ca-certificates lsb-release apt-transport-https

# Add the Ondřej PHP PPA repository (for multiple PHP versions)
echo "Adding Ondrej PHP repository..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y

# Install Nginx
echo "Installing Nginx..."
sudo apt install -y nginx

# Install PHP and PHP-FPM
echo "Installing PHP $PHP_VERSION and required extensions..."
sudo apt install -y php$PHP_VERSION php$PHP_VERSION-fpm php$PHP_VERSION-cli php$PHP_VERSION-mbstring php$PHP_VERSION-xml php$PHP_VERSION-curl php$PHP_VERSION-mysql php$PHP_VERSION-zip php$PHP_VERSION-mysqli

# Enable and start Nginx and PHP-FPM services
echo "Enabling and starting Nginx and PHP-FPM..."
sudo systemctl enable nginx
sudo systemctl start nginx

sudo systemctl enable php$PHP_VERSION-fpm
sudo systemctl start php$PHP_VERSION-fpm

# Configure Nginx to use PHP-FPM
echo "Configuring Nginx for PHP..."
NGINX_CONF="/etc/nginx/sites-available/default"

sudo tee $NGINX_CONF > /dev/null <<EOL
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;
    
    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php$PHP_VERSION-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOL

# Restart Nginx to apply changes
echo "Restarting Nginx to apply configuration..."
sudo systemctl restart nginx
