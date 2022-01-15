# hcloud-doorkeeper-action
This GitHub action opens and closes a port for a specific IP(range) in a Hetzner Cloud firewall. This allows access to "internal" resources for the current github runner.

By default the opened port is automatically being closed in a post script running after any `main:`steps.

## Limits and Dependencies

### Runtime

* Requires a github runner with docker capabilities
* A valid hcloud token and an existing hcloud firewall are required
* If the IP address is to be determined dynamically, a connection to [ifconfig.me](http://ifconfig.me) is required

## Inputs

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| **`hcloud_token`** | True | | Hetzner Cloud token to access the Firewall |
| **`firewall_name`** | True | | Name of firewall to configure |
| `ip`| False | current runner IP* | Which IP(range) to allow access; in [CIDR](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) notation |
| `port`| False | 22 | Port to open |
| `protocol`| False | tcp | Protocol for the aboce port. Either `tcp` or `udp` |
| `autoclean` | False | True |  Automatically clean up the opened port after the workflow finishes |

*) as determined by a call to http://ifconfig.me/ip

## Examples

### *Permanently* allow IP Range 10.1.0.1-10.1.255.254 to access port 1234/tcp

``` yaml
name: Example

on:
  push:
    branches: [ master ]

jobs:
  myjob:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: 5nafu/hcloud-doorkeeper-action@v1
      with:
        hcloud_token: ${{ secrets.hcloud_token }}
        firewall_name: MyFirewall
        ip: 10.1.0.0/16
        port: 1234
        protocol: tcp
        autoclean: false
```

### *Temporarily* allow the current GitHub runner to access port 443/tcp

``` yaml
name: Example

on:
  push:
    branches: [ master ]

jobs:
  myjob:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: 5nafu/hcloud-doorkeeper-action@v1
      with:
        hcloud_token: ${{ secrets.hcloud_token }}
        firewall_name: MyFirewall
        port: 443
        protocol: tcp
```