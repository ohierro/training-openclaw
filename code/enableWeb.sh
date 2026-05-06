#!/bin/bash

echo "Configuring OpenClaw CLI tool to enable remote web access..."

CONFIG_FILE="$HOME/.openclaw/openclaw.json"

if [ -f "$CONFIG_FILE" ] && jq -e '.gateway.controlUi' "$CONFIG_FILE" > /dev/null 2>&1; then
    tmp=$(mktemp)
    jq '.gateway.controlUi += {"allowedOrigins": ["*"], "dangerouslyDisableDeviceAuth": true}' "$CONFIG_FILE" > "$tmp" && mv "$tmp" "$CONFIG_FILE"
fi