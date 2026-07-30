#!/bin/bash
set -e

echo "🌳 Starting Land of Ooo Datacenter..."
echo "========================================"
echo "  X-UI + Nginx with 'Land of Ooo' mode"
echo "  Real-IP: Cloudflare / ArvanCloud"
echo "========================================"

# ============================================================
# 🔧 تنظیم پورت داخلی Nginx برای Railway
# ============================================================
export NGINX_PORT=3000

cd /usr/local/x-ui

# ============================================================
# ⚙️ تنظیمات 3x-ui (پورت پنل و مسیر)
# ============================================================
echo "📊 Configuring 3x-ui panel..."
./x-ui setting -port 2053 -webBasePath /managepanel/ || true

# ============================================================
# 📄 تولید nginx.conf از template با متغیرها
# ============================================================
echo "📄 Generating nginx.conf with Ooo mode..."
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# ============================================================
# 🚀 اجرای 3x-ui در پس‌زمینه
# ============================================================
echo "🚀 Starting 3x-ui..."
./x-ui &

sleep 3

# ============================================================
# 🌳 اجرای Nginx با تنظیمات «سرزمین اوو»
# ============================================================
echo "🌳 Starting Nginx with 'Land of Ooo' filters..."
nginx -t
exec nginx -g "daemon off;"
