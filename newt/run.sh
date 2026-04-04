#!/usr/bin/env bashio

bashio::log.info "Starting the Newt Add-on..."

# ---------------------------------------------------------
# 1. Map Home Assistant Config to Environment Variables
# ---------------------------------------------------------
# Your README mentions Newt needs environment variables.
# You will read the options users set in the Home Assistant UI
# (defined in your config.yaml) and export them here.

# Example: If you have a config option called 'pangolin_token'
# if bashio::config.has_value 'pangolin_token'; then
#     export PANGOLIN_TOKEN=$(bashio::config 'pangolin_token')
# fi

# Example: If you have a config option called 'listen_port'
# if bashio::config.has_value 'listen_port'; then
#     export NEWT_LISTEN_PORT=$(bashio::config 'listen_port')
# fi

# ---------------------------------------------------------
# 2. Execute the Application
# ---------------------------------------------------------
bashio::log.info "Executing /usr/bin/newt..."

# Use 'exec' to replace the bash process with the newt process
# so that Home Assistant can properly track its state and shut it down.
exec /usr/bin/newt
