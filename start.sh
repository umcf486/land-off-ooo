#!/bin/bash
set -e

echo "🌳 ========================================"
echo "🌳   LAND OF OOO DATACENTER"
echo "🌳   All IPs will show as 🌳✨"
echo "🌳 ========================================"

export NGINX_PORT=3000

cd /usr/local/x-ui

echo "📊 Configuring 3x-ui panel..."
./x-ui setting -port 2053 -webBasePath /managepanel/ || true

echo "📄 Generating nginx.conf with Ooo mode..."
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "🔍 Testing Nginx configuration..."
nginx -t

echo "🚀 Starting 3x-ui..."
./x-ui &

sleep 3

echo "🌳 Starting Nginx with 'All IPs to Ooo' filters..."
exec nginx -g "daemon off;"
