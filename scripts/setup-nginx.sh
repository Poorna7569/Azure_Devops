#!/bin/bash
# Nginx Setup and Load Balancing Configuration Script
# This script configures Nginx as a reverse proxy and load balancer for the two Flask instances

set -e

echo "=== Nginx Load Balancing Setup ==="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo "This script must be run as root (use sudo)"
   exit 1
fi

# Update system packages
echo "Updating system packages..."
apt-get update
apt-get install -y nginx

# Stop Nginx before making changes
echo "Stopping Nginx..."
systemctl stop nginx

# Remove the default Nginx configuration
echo "Removing default Nginx configuration..."
rm -f /etc/nginx/sites-enabled/default

# Create the upstream load balancing configuration
echo "Creating Nginx load balancing configuration..."
cat > /etc/nginx/sites-available/flask-loadbalancer << 'EOF'
upstream backend_app {
    server 127.0.0.1:8001;
    server 127.0.0.1:8002;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://backend_app;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Connection settings
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF

# Enable the configuration by creating a symbolic link
echo "Enabling the configuration..."
ln -sf /etc/nginx/sites-available/flask-loadbalancer /etc/nginx/sites-enabled/flask-loadbalancer

# Test Nginx configuration
echo "Testing Nginx configuration..."
nginx -t

# Reload Nginx
echo "Reloading Nginx..."
systemctl reload nginx

echo "=== Nginx setup completed successfully ==="
echo ""
echo "Nginx is now configured to load-balance traffic between:"
echo "  - Flask App 1: 127.0.0.1:8001"
echo "  - Flask App 2: 127.0.0.1:8002"
echo ""
echo "To verify, run:"
echo "  curl http://<VM_PUBLIC_IP>"
echo ""
echo "You should see responses from both backends by running the command multiple times."
