# Unofficial Home Assistant Add-ons: Traefik

Traefik bundled as an Home Assistant add-on.

### This was forked and updated from an inactive github project [here](https://alxx.nl/home-assistant-addons/) -  
99% of the work on this was done by [alex3305](https://github.com/alex3305), i have simply updated the code to deploy the latest Traefik release.

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to __Supervisor -> Add-on Store__
2. Add this new repository by URL (`https://github.com/boomam/home-assistant-addons`)
3. Find the "Traefik" add-on and click it.
4. Click on the "INSTALL" button

## How to use

In the configuration section you will need to set the required configuration path.  
On the configuration tab, this is the entry called `dynamic_configuration_path`.  
If you set it to `/config/traefik`, the actual location on HA will be the root of your configuration directory (where configuration.yaml typically is), within a directory called 'Traefik'.  
_Note, you will need to create that directory, and the initial traefik dynamic file configuration manually._

With Traefik, a dynamic configuration refers to the file you would put in this `fileConfig.yaml`, and dynamically loads it on each save of the file.

As a config to get started, the below can be created and copied as-is for basic functionality -  
_Make sure you are updating your domain on the rule sections for homeassistant_
```yaml
http:
  routers:
    httpsredirect:
      entryPoints: 
        - "web"
      middlewares: 
        - "httpsRedirect"
      rule: "HostRegexp(`{host:.+}`)"
      service: httpsredirect
      
    homeassistant:
      rule: "Host(`home.domain.com`)"
      entryPoints: 
        - "websecure"
      tls:
        certResolver: le
      service: homeassistant

  middlewares:
    httpsRedirect:
      redirectScheme:
        scheme: https

  services:
    httpsredirect:
      loadBalancer:
        servers:
          - url: "http://homeassistant"
  
    homeassistant:
      loadBalancer:
        servers:
          - url: "http://homeassistant:8123"
        passHostHeader: true
```

You can also enable Let's Encrypt support within the configuration and set additional environment variables when those are needed.
This add-on provides three Traefik entrypoints. 
- `web` on port 80. 
- `websecure` on port 443.
- `traefik` on port 8080.

## Configuration
### Option `log_level` (required)

The `log_level` option controls the level of log verbosity by the addon and can be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue.  
Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`:  Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.
- `panic`: Run for the hills

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages.  
By default, the `log_level` is set to `error`, which is the recommended setting unless you are troubleshooting.

### Option `access_logs` (required)

Whether to enable access logging to standard out.  
These logs will be shown in the Hass.io Add-On panel.

### Option `forwarded_headers_insecure` (required)

Enables insecure forwarding headers.  
When this option is enabled, the forwarded headers (`X-Forwarded-*`) will not be replaced by Traefik headers. Only enable this option when you trust your forwarding proxy.  

> ___Note__ for Cloudflare `X-Forwarded-*` proxied headers to work, this must be enabled._

### Option `forwarded_headers_insecure` (required)

Enables insecure forwarding headers.  
When this option is enabled, the forwarded headers (`X-Forwarded-*`) will not be replaced by Traefik headers. Only enable this option when you trust your forwarding proxy.  

> ___Note__ for Cloudflare `X-Forwarded-*` proxied headers to work, this must be enabled._

### Option `insecure_skip_verify` (required)

Disables SSL certificate verification
Useful for self-signed certificates used by services

### Option `letsencrypt` (required)

Whether or not to enable Let's Encrypt.  
When there is data within this section, the `le` certResolver will be activated.  
You will also have to set the Let's Encrypt e-mail and challange type. Otherwise Traefik will fail to start.

#### LetsEncrypt Options
| What | Info needed | Example |
| ----- | ----- | ----- |
| enabled | true/false | `true` |
| resolvers | Manually set the DNS servers to use when performing the verification step. Useful for situations where internal DNS does not resolve to the same addresses as the public internet (e.g. on a LAN using a FQDN as part of hostnames). | `resolvers: 1.1.1.1:53` | 
| email | your email address | `email: user@domain.com` |
| challenge_type | `tlsChallenge`, `httpChallenge`, `dnsChallenge` | `challenge_type: dnsChallenge` |
| provider | The list of providers can be found in the [Let's Encrypt provider section](https://docs.traefik.io/https/acme/#providers) of the Traefik documentation. | `provider: cloudflare` |
| delayBeforeCheck | By default, the provider will verify the TXT DNS challenge record before letting ACME verify.  If `delayBeforeCheck` is set and greater than zero, this check is delayed for the configured duration in seconds. | `delayBeforeCheck: 10` |

### Option `custom_config`

This option allows expert users to completely bypass the standard built-in add-on configuration (such as Let's Encrypt, Log Level, etc.) and run Traefik with their own static configuration. 

> **⚠️ WARNING:** When the toggle inside `custom_config` is enabled, ALL standard configuration options above it in the configuration UI will be ignored.

#### Custom Config Options
| What | Info needed | Example |
| ----- | ----- | ----- |
| use_config_file | Toggle to enable running Traefik with a static configuration file. | `use_config_file: true` |
| config_file | The absolute path to your static configuration file inside the Home Assistant container when `use_config_file` is enabled. | `config_file: "/config/traefik/traefik.yaml"` |

### Option `env_vars`

Optional environment variables that can be added. These additional configuration values can be necessary for example for the Let's Encrypt DNS challange provider. See the example configuration above for an concrete example.

## Entrypoints

This image exposes three ports for HTTP(S) access.  
These are also configured within Traefik as entrypoints. You can use these within your dynamic configuration.

### EntryPoint `web`, port `80`

Port 80 is used for HTTP access. 

When using a supported Let's Encrypt provider (ie. Cloudflare) with DNS Challange you can also map this port to another, random port and let CloudFlare do the HTTP to HTTPS forwarding.

### EntryPoint `websecure`, port `443`

Port 443 is used for HTTPS access.

### EntryPoint `traefik`, port `8080`
Port 8080 is used for access to the Traefik dashboard.