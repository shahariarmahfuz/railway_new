FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# প্রয়োজনীয় প্যাকেজ ইনস্টল
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    iptables \
    sudo \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Tailscale ইনস্টল
RUN curl -fsSL https://tailscale.com/install.sh | sh

# স্ক্রিপ্ট কপি ও পারমিশন প্রদান
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
