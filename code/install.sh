#!/bin/bash

echo "Installing nvm (Node Version Manager)..."

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo "Install Node.js 24"

nvm install 24

echo "Installing OpenClaw CLI tool..."

npm install -g openclaw@2026.4.12


echo "Configuring OpenClaw CLI tool to enable remote web access..."

CONFIG_FILE="$HOME/.openclaw/openclaw.json"

if [ -f "$CONFIG_FILE" ] && jq -e '.controlUi' "$CONFIG_FILE" > /dev/null 2>&1; then
    tmp=$(mktemp)
    jq '.controlUi += {"allowedOrigins": ["*"], "dangerouslyDisableDeviceAuth": true}' "$CONFIG_FILE" > "$tmp" && mv "$tmp" "$CONFIG_FILE"
fi

echo "Launching OpenClaw install"

openclaw onboard --install-daemon

echo "Installation complete. Please restart your terminal for the changes to take effect."