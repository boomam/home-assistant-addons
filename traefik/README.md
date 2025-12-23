# Unofficial Home Assistant Add-ons: Traefik

Traefik bundled as an Home Assistant add-on.

![aarch64-shield](https://img.shields.io/badge/aarch64-yes-green)
![amd64-shield](https://img.shields.io/badge/amd64-yes-green)
![armhf-shield](https://img.shields.io/badge/armhf-yes-green)
![armv7-shield](https://img.shields.io/badge/armv7-yes-green)
![i386-shield](https://img.shields.io/badge/i386-yes-green)

[![Update Traefik Version](https://github.com/boomam/home-assistant-addons/actions/workflows/traefik-update-version.yml/badge.svg)](https://github.com/boomam/home-assistant-addons/actions/workflows/traefik-update-version.yml)  
[![Build and test Traefik](https://github.com/boomam/home-assistant-addons/actions/workflows/build_traefik.yml/badge.svg)](https://github.com/boomam/home-assistant-addons/actions/workflows/build_traefik.yml)

## About
### This was forked and updated from an inactive github project [here](https://alxx.nl/home-assistant-addons/) -  
99% of the work on this was done by [alex3305](https://github.com/alex3305), i have simply updated the code to deploy the latest Traefik release and added some additional bits here and there.  

Traefik is a modern HTTP reverse proxy and load balancer that makes deploying microservices easy. This add-on provides dynamic Traefik configuration based on files.  

[Click here for the full Traefik documentation](https://docs.traefik.io/)  

## Configuration
During configuration, make sure you are adding `CF_DNS_API_TOKEN` and your Cloudflare API Token as an `env_var`, if you are using Cloudflare for your ACME cert verifications.  

## Known issues and limitations

* Default port 80 can conflict with other ports  
* Log level of 'warning/warn' does not work at this time, other log levels are fine - Default is 'error'.  
~~* Sidebar for Traefik does not render correctly - accessing via port (http://IP:8080/dashboard) is the current workaround.~~  

## Final notes

This project is not affiliated with Traefik, the Traefik Maintainer Team or Containous, but simply a community effort.  
Traefik itself is distributed under the [MIT License](https://github.com/containous/traefik/blob/master/LICENSE.md).  
