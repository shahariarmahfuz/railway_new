#!/bin/bash
set -e

echo "Starting Tailscale in userspace networking mode..."

# Tailscale ব্যাকগ্রাউন্ডে রান
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &

# tailscaled সকেট রেডি হওয়া পর্যন্ত অপেক্ষা
until [ -S /var/run/tailscale/tailscaled.sock ]; do
  sleep 0.5
done

echo "Tailscale daemon is ready. Authenticating..."

# Railway Variables থেকে টোকেন নিয়ে লগইন
if [ -n "$TS_AUTHKEY" ]; then
  tailscale up --authkey="${TS_AUTHKEY}" --ssh --hostname="${TS_HOSTNAME:-railway-ubuntu}"
  echo "Tailscale connected successfully!"
else
  echo "ERROR: TS_AUTHKEY variable is missing in Railway!"
  exit 1
fi

# কন্টেইনার যেন বন্ধ না হয়
exec tail -f /dev/null
