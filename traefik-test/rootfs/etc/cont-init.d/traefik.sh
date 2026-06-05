#!/usr/bin/with-contenv bashio

bashio::log.info "Ensuring SSL directory..."
mkdir -p /ssl/traefik/

if bashio::config.true 'custom_config.use_config_file'; then
    bashio::log.info "Custom config enabled, skipping built-in static config generation."
else
    bashio::log.info "Generating static config..."
    gomplate -f /etc/traefik/traefik.yaml.gotmpl -d options=/data/options.json -o /etc/traefik/traefik.yaml
    bashio::log.info "Static config generated"
fi