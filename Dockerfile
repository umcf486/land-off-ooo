FROM alpine:3.19

# ============================================================
# نصب پیش‌نیازها
# ============================================================
RUN apk add --no-cache \
    curl \
    bash \
    ca-certificates \
    socat \
    tzdata \
    sqlite \
    nginx \
    nginx-mod-stream \
    nginx-mod-http-sub \
    gettext \
    && ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime

# ============================================================
# دانلود و نصب 3x-ui
# ============================================================
RUN curl -L https://github.com/mhsanaei/3x-ui/releases/download/v3.5.0/x-ui-linux-amd64.tar.gz -o /tmp/x-ui.tar.gz \
    && tar -xzf /tmp/x-ui.tar.gz -C /usr/local/ \
    && rm /tmp/x-ui.tar.gz \
    && chmod +x /usr/local/x-ui/x-ui

RUN mkdir -p /etc/x-ui /var/log/x-ui

# ============================================================
# کپی فایل‌های کانفیگ و اسکریپت‌ها
# ============================================================
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /start.sh
RUN chmod +x /start.sh

# ============================================================
# پورت‌های مورد نیاز
# ============================================================
EXPOSE 3000 2053 2096 8001-8050 8080

# ============================================================
# ورودی
# ============================================================
CMD ["/start.sh"]
