#!/bin/bash
set -e

echo "🌳 Starting Land of Ooo Datacenter..."
echo "========================================"
echo "  X-UI + Nginx with 'All IPs to Ooo' mode"
echo "  Real-IP: Cloudflare / ArvanCloud"
echo "  Every IP will be shown as 🌳✨"
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
# 🔍 اطمینان از نصب ماژول‌های Nginx
# ============================================================
echo "🔍 Checking Nginx modules..."
nginx -V 2>&1 | grep -q "http_sub_module" || echo "⚠️ sub_filter module may not be installed"
nginx -V 2>&1 | grep -q "http_ssl_module" || echo "⚠️ ssl module may not be installed"

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
# 🌳 اجرای Nginx با تنظیمات «همه‌ی آی‌پی‌ها به اوو»
# ============================================================
echo "🌳 Starting Nginx with 'All IPs to Ooo' filters..."
nginx -t
exec nginx -g "daemon off;"
