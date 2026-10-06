#!/bin/bash
set -e

echo "Starting Tailscale in userspace networking mode..."

# Railway-তে TUN ডিভাইস না থাকায় userspace-networking মোড বাধ্যতামূলক
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &

# tailscaled সার্ভিস চালু হওয়া পর্যন্ত অপেক্ষা
until tailscale status &>/dev/null; do
  sleep 1
done

# Railway-এর Variables থেকে কী নিয়ে লগইন ও SSH চালু করা
if [ -n "$TS_AUTHKEY" ]; then
  echo "Authenticating Tailscale..."
  tailscale up --authkey="${TS_AUTHKEY}" --ssh --hostname="${TS_HOSTNAME:-railway-ubuntu}"
  echo "Tailscale connected successfully!"
else
  echo "ERROR: TS_AUTHKEY variable is missing!"
  exit 1
fi

# কন্টেইনার চালু রাখতে
exec tail -f /dev/null
