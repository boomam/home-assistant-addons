# Unofficial Home Assistant Add-ons: Tailscale

Tailscale bundled as an Home Assistant add-on.

### This was forked and updated from an this github project [here](https://github.com/hassio-addons/addon-tailscale) -  
99% of the work on this was done by [frenck](https://github.com/frenck), i have simply updated the code to deploy the latest Tailscale releases.

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to __Supervisor -> Add-on Store__
2. Add this new repository by URL (`https://github.com/boomam/home-assistant-addons`)
3. Find the "Tailscale" add-on and click it.
4. Click on the "INSTALL" button

This add-on has almost no additional configuration options for the
add-on itself.

However, when logging in to Tailscale, you can configure your Tailscale
network right from their interface.

<https://login.tailscale.com/>

The add-on exposes "Exit Node" capabilities that you can enable from your
Tailscale account. Additionally, if the Supervisor managed your network (which
is the default), the add-on will also advertise routes to your subnets on all
supported interfaces to Tailscale.

Consider disabling key expiry to avoid losing connection to your Home Assistant
device. See [Key expiry][tailscale_info_key_expiry] for more information.

```yaml
accept_dns: true
accept_routes: true
advertise_exit_node: true
advertise_connector: true
advertise_routes:
  - 192.168.1.0/24
  - fd12:3456:abcd::/64
log_level: info
login_server: "https://controlplane.tailscale.com"
share_homeassistant: disabled
share_on_port: 443
snat_subnet_routes: true
stateful_filtering: false
tags:
  - tag:example
  - tag:homeassistant
taildrop: true
userspace_networking: true
```

> [!NOTE]
> Some of the configuration options are also available on Tailscale's web
> interface through the Web UI, but they are made read only there. You can't
> change them through the Web UI, because all the changes made there would be
> lost when the add-on is restarted.

### Option: `accept_dns`

If you are experiencing trouble with MagicDNS on this device and wish to
disable, you can do so using this option.

When not set, this option is enabled by default.

MagicDNS may cause issues if you run things like Pi-hole or AdGuard Home
on the same machine as this add-on. In such cases disabling `accept_dns`
will help. You can still leverage MagicDNS on other devices on your network,
by adding `100.100.100.100` as a DNS server in your Pi-hole or AdGuard Home.

### Option: `accept_routes`

This option allows you to accept subnet routes advertised by other nodes in
your tailnet.

More information: [Subnet routers][tailscale_info_subnets]

When not set, this option is enabled by default.

### Option: `advertise_exit_node`

This option allows you to advertise this Tailscale instance as an exit node.

By setting a device on your network as an exit node, you can use it to
route all your public internet traffic as needed, like a consumer VPN.

More information: [Exit nodes][tailscale_info_exit_nodes]

When not set, this option is enabled by default.

### Option: `advertise_connector`

This option allows you to advertise this Tailscale instance as an app connector.

When you use an app connector, you specify which applications you wish to make
accessible over your tailnet, and the domains for those applications. Any traffic
for that application is then forced over the tailnet to a node running an app
connector before egressing to the target domains. This is useful for cases where
the application has an allowlist of IP addresses which can connect to it: the IP
address of the node running the app connector can be added to the allowlist, and
all nodes on the tailnet will use that IP address for their traffic egress.

More information: [App connectors][tailscale_info_app_connectors]

When not set, this option is enabled by default.

### Option: `advertise_routes`

This option allows you to advertise routes to subnets (accessible on the network
your device is connected to) to other clients on your tailnet.

By adding to the list the IP addresses and masks of the subnet routes, you can
use it to make your devices on these subnets accessible within your tailnet.

If you want to disable this option, specify an empty list in the configuration
(`[]` in YAML).

More information: [Subnet routers][tailscale_info_subnets]

When not set, the add-on by default will advertise routes to your subnets on all
supported interfaces.

### Option: `log_level`

Optionally enable tailscaled debug messages in the add-on's log. Turn it on only
in case you are troubleshooting, because Tailscale's daemon is quite chatty. If
`log_level` is set to `info` or less severe level, the add-on also opts out of
client log upload to log.tailscale.io.

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `notice`: Normal but significant events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `login_server`

This option lets you to specify a custom control server instead of the default
(`https://controlplane.tailscale.com`). This is useful if you are running your
own Tailscale control server, for example, a self-hosted [Headscale] instance.

### Option: `share_homeassistant`

This option allows you to enable Tailscale Serve or Funnel features to present
your Home Assistant instance with a valid certificate on your tailnet or on the
internet.

When not set, this option is disabled by default.

Tailscale can provide a TLS certificate for your Home Assistant instance within
your tailnet domain.

This can prevent browsers from warning that HTTP URLs to your Home Assistant
instance look unencrypted (browsers are not aware that the connections between
Tailscale nodes are secured with end-to-end encryption).

With the Tailscale Serve feature, you can access your Home Assistant instance
with the provided certificate within your tailnet from devices already connected
to your tailnet.

With the Tailscale Funnel feature, you can access your Home Assistant instance
with the provided certificate not only within your tailnet but even from the
wider internet using your Tailscale domain (like
`https://homeassistant.tail1234.ts.net`) from devices **without installed
Tailscale VPN client** (for example, on general phones, tablets, and laptops).

**Client** &#8658; _Internet_ &#8658; **Tailscale Funnel** (TCP proxy) &#8658;
_VPN_ &#8658; **Tailscale Serve** (HTTPS proxy) &#8594; **HA** (HTTP web-server)

More information: [Enabling HTTPS][tailscale_info_https],
[Tailscale Serve][tailscale_info_serve], [Tailscale Funnel][tailscale_info_funnel].

1. Configure Home Assistant to be accessible through an HTTP connection (this is
   the default). See [HTTP integration documentation][http_integration] for more
   information. If you still want to use another HTTPS connection to access Home
   Assistant, please use a reverse proxy add-on.

1. Home Assistant, by default, blocks requests from reverse proxies, like the
   Tailscale Serve. To enable it, add the following lines to your
   `configuration.yaml`, without changing anything:

   ```yaml
   http:
     use_x_forwarded_for: true
     trusted_proxies:
       - 127.0.0.1
   ```

1. Navigate to the [DNS page][tailscale_dns] of the admin console:
   - Choose a tailnet name.

   - Enable MagicDNS if not already enabled.

   - Under HTTPS Certificates section, click Enable HTTPS.

1. Optionally, if you want to use Tailscale Funnel, navigate to the [Access
   controls page][tailscale_acls] of the admin console:
   - Add the required `funnel` node attribute to the tailnet policy file. See
     [Tailnet policy file requirement][tailscale_info_funnel_policy_requirement]
     for more information.

1. Restart the add-on.

**Note**: After initial setup, it can take up to 10 minutes for the domain to
be publicly available.

**Note:** You should not use the port number in the URL that you used
previously to access Home Assistant. Tailscale Serve and Funnel works on the
default HTTPS port 443 (or the port configured in option `share_on_port`).

**Note:** If you encounter strange browser behaviour or strange error messages,
try to clear all site-related cookies, clear all browser cache, and restart the
browser.

### Option: `share_on_port`

This option lets you specify which port the Tailscale Serve and Funnel features
will use to present your Home Assistant instance on the tailnet and on the
internet.

Only ports 443, 8443, and 10000 are allowed by Tailscale.

When not set, port 443 is used by default.

### Option: `snat_subnet_routes`

This option allows subnet devices to see the traffic originating from the subnet
router, and this simplifies routing configuration.

When not set, this option is enabled by default.

To support advanced [Site-to-site networking][tailscale_info_site_to_site] (e.g.
to traverse multiple networks), you can disable this functionality, and follow
steps in the [Site-to-site networking][tailscale_info_site_to_site] guide (Note:
The add-on already handles "IP address forwarding" and "Clamp the MSS to the
MTU" for you).

**Note:** Only disable this option if you fully understand the implications.
Keep it enabled if preserving the real source IP address is not critical for
your use case.

### Option: `stateful_filtering`

This option enables stateful packet filtering on packet-forwarding nodes (exit
nodes, subnet routers, and app connectors), to only allow return packets for
existing outbound connections. Inbound packets that don't belong to an existing
connection are dropped.

When not set, this option is disabled by default.

### Option: `tags`

This option allows you to specify specific tags for this Tailscale instance.
They need to start with `tag:`.

More information: [Tags][tailscale_info_tags]

### Option: `taildrop`

This add-on supports [Tailscale's Taildrop][tailscale_info_taildrop] feature,
which allows you to send files to your Home Assistant instance from other
Tailscale devices.

When not set, this option is enabled by default.

Received files are stored in the `/share/taildrop` directory.

### Option: `userspace_networking`

The add-on uses [userspace networking mode][tailscale_info_userspace_networking]
to make your Home Assistant instance (and optionally the local subnets)
accessible within your tailnet.

When not set, this option is enabled by default.

If you need to access other clients on your tailnet from your Home Assistant
instance, disable userspace networking mode, which will create a `tailscale0`
network interface on your host. To be able to address those clients not only
with their tailnet IP, but with their tailnet name, you have to configure Home
Assistant's DNS options also.

If you want to access other clients on your tailnet even from your local subnet,
follow steps in the [Site-to-site networking][tailscale_info_site_to_site] guide
(Note: The add-on already handles "IP address forwarding" and "Clamp the MSS to
the MTU" for you).

**Note:** In case your local subnets collide with subnet routes within your
tailnet, your local network access has priority, and these addresses won't be
routed toward your tailnet. This will prevent your Home Assistant instance from
losing network connection. This also means that using the same subnet on
multiple nodes for load balancing and failover is impossible with the current
add-on behavior.

**Note:** The `userspace_networking` option can remain enabled if you only need
one-way access from tailnet clients to your local subnet, without requiring
access from your local subnet to other tailnet clients.

**Note:** If you implement Site-to-site networking, but you are not interested
in the real source IP address, i.e. subnet devices can see the traffic
originating from the subnet router, you don't need to disable the
`snat_subnet_routes` option, this can simplify routing configuration.

## Network

### Port: `41641/udp`

UDP port to listen on for WireGuard and peer-to-peer traffic.

Use this option (and router port forwarding) if you experience that Tailscale
can't establish peer-to-peer connections to some of your devices (usually behind
CGNAT networks). You can test connections with `tailscale ping
<hostname-or-ip>`.

When not set, an automatically selected port is used by default.