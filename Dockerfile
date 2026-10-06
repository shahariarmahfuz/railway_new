FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    iptables \
    sudo \
    bash \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://tailscale.com/install.sh | sh

CMD tailscaled --tun=userspace-networking & \
    until [ -S /var/run/tailscale/tailscaled.sock ]; do sleep 0.5; done && \
    tailscale up --authkey="${TS_AUTHKEY}" --ssh --hostname="${TS_HOSTNAME:-railway-ubuntu}" && \
    tail -f /dev/null
