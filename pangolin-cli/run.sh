#!/usr/bin/env bash
set -e

echo "Starting Pangolin-CLI..."

CONFIG_PATH="/data/options.json"
HEALTH_FILE="${HEALTH_FILE:-/tmp/healthy}"

export HEALTH_FILE

if [[ ! -f "$CONFIG_PATH" ]]; then
    echo "ERROR: Configuration file not found at $CONFIG_PATH!"
    exit 1
fi

PANGOLIN_ENDPOINT=$(jq -r '.PANGOLIN_ENDPOINT' "$CONFIG_PATH")
SITE_ID=$(jq -r '.SITE_ID' "$CONFIG_PATH")
SITE_SECRET=$(jq -r '.SITE_SECRET' "$CONFIG_PATH")

# Read custom env variables
CUSTOM_ENV_VARS=$(jq -r '.custom_env_vars // [] | .[]' "$CONFIG_PATH")

if [[ -z "$PANGOLIN_ENDPOINT" || "$PANGOLIN_ENDPOINT" == "null" || \
      -z "$SITE_ID" || "$SITE_ID" == "null" || \
      -z "$SITE_SECRET" || "$SITE_SECRET" == "null" ]]; then
    echo "ERROR: Missing minimum required configuration values!"
    exit 1
fi

echo "Configuration Loaded:"
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  SITE_ID=$SITE_ID"
echo "  SITE_SECRET=$SITE_SECRET"
echo "  HEALTH_FILE=$HEALTH_FILE"

# Export minimum required variables
export PANGOLIN_ENDPOINT="$PANGOLIN_ENDPOINT"
export SITE_ID="$SITE_ID"
export SITE_SECRET="$SITE_SECRET"

# Process & export custom environment variables
if [[ -n "$CUSTOM_ENV_VARS" ]]; then
    echo "✅ Custom Environment Variables:"
    while IFS= read -r env_var; do
        if [[ -n "$env_var" ]]; then
            echo "  $env_var"
            export "$env_var"
        fi
    done <<< "$CUSTOM_ENV_VARS"
fi

# Auto-reconnect loop
while true; do
    echo "🔹 Starting Pangolin-CLI..."

    # Remove stale health file before starting
    rm -f "$HEALTH_FILE"

    /usr/bin/pangolin-cli

    echo "Pangolin-CLI stopped! Waiting 5 seconds before reconnecting..."
    sleep 5
done
