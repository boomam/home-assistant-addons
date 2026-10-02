## Usage

1. Navigate in your Home Assistant frontend to __Supervisor -> Add-on Store__
2. Add this new repository by URL (`https://github.com/boomam/home-assistant-addons`)
3. Find the add-on that you want to use and click it
4. Click on the "INSTALL" button

## Add-ons
| Name | Readme | Statuses |
| ----- | ----- | ----- |
| Traefik | [Traefik](traefik/README.md) | [![Update Traefik Version](https://github.com/boomam/home-assistant-addons/actions/workflows/traefik-update-version.yml/badge.svg)](https://github.com/boomam/home-assistant-addons/actions/workflows/traefik-update-version.yml)  [![Build and test Traefik](https://github.com/boomam/home-assistant-addons/actions/workflows/test_build_traefik.yml/badge.svg)](https://github.com/boomam/home-assistant-addons/actions/workflows/test_build_traefik.yml)|
| Tailscale | [Tailscale](tailscale/README.md) | [![Update Tailscale Version](https://github.com/boomam/home-assistant-addons/actions/workflows/tailscale-update-version.yml/badge.svg?branch=master)](https://github.com/boomam/home-assistant-addons/actions/workflows/tailscale-update-version.yml)  [![Build and test Tailscale](https://github.com/boomam/home-assistant-addons/actions/workflows/test_build_tailscale.yml/badge.svg)](https://github.com/boomam/home-assistant-addons/actions/workflows/build_tailscale.yml) |
| Newt | [Newt](newt/README.md) | [![Update Newt Version](https://github.com/boomam/home-assistant-addons/actions/workflows/newt-update-version.yml/badge.svg?branch=master)](https://github.com/boomam/home-assistant-addons/actions/workflows/newt-update-version.yml)  [![Build and test Newt](https://github.com/boomam/home-assistant-addons/actions/workflows/test_build_newt.yml/badge.svg)](https://github.com/boomam/home-assistant-addons/actions/workflows/test_build_newt.yml) |
| Pangolin-CLI | [Pangolin-CLI ](pangolin-cli/README.md) | [![Update Pangolin-CLI Version](https://github.com/boomam/home-assistant-addons/actions/workflows/pangolin-cli-update-version.yml/badge.svg)](https://github.com/boomam/home-assistant-addons/actions/workflows/pangolin-cli-update-version.yml)  [![Build and test Pangolin-CLI](https://github.com/boomam/home-assistant-addons/actions/workflows/test_build_pangolin-cli.yml/badge.svg)](https://github.com/boomam/home-assistant-addons/actions/workflows/test_build_pangolin-cli.yml) |

## Troubleshooting (not app specific)
### Addons/Store wont open/load
Sometimes there can be a mismatch of version numbers caused by an upstream addon having a 'null' value in the `config.yaml` that HA uses to determine versions numbers and if updates are available. This can be caused for all manner of reasons, but also can be caused by a rate limited GitHub release page causing a null value.  
That should mostly be fine in the case of this repo, but if you experience it, these are the resolution steps -   

#### Get Access to host terminal
If you have physical access to your Home Assistant, plug in a keyboard and monitor.  
If you dont, follow the steps here to enable remote SSH, then SSH in - https://developers.home-assistant.io/docs/operating-system/debugging/

#### Identify faulty addon
Run in the CLI session, this -  
`docker exec hassio_supervisor grep -R -nE '^[[:space:]]*version:' /data/apps/local /data/apps/git`  
Check every outputted line, for a version value that shows anything other than a number.  

#### Correct faulty config.yaml
Using the CLI, browse to the same config.yaml location listed on the previous output, then 'cat' it, so you can see the version number line.  
(important to note that the command above can also list 'version' in other parts, but its the one on its own you need.)  
Once you've identified it, use Vi to edit the file and correct the version number to match the upstream repo (ideally) or just something that can parse, like `1.0`.  
Once edited and saved, run `ha supervisor restart`, then after a minute, run `ha apps list` - if you see your apps outputted in the list, its fixed, wait a few more mins, then the webGUI will be functional again.  
