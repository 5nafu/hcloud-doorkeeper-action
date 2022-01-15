# hcloud-doorkeeper-action
This GitHub action opens and closes a port for a specific IP(range) in a Hetzner Cloud firewall. This allows access to "internal" resources for the current github runner.

By default the opened port is automatically being closed in a post script running after any `main:`steps.

The Rules are uniquely named like "Doorkeeper Rule - Repository `REPOSITORY` - Workflow: `WORKFLOW`/`RUN_NUMBER`/`RUN_ATTEMPT`" so not to disturb existing rules and to allow multiple workflows to run simultaneously.

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
    # Your own steps... for example
    - run: sleep 30s
      shell: bash
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
    # Your own steps... for example
    - run: sleep 30s
      shell: bash
```

## Development

### Requirements

* a copy of this source code
* a running docker daemon
* a [Hetzner cloud account](https://console.hetzner.cloud/) with [API token](https://docs.hetzner.cloud/#getting-started) (read/write!) and an (empty) firewall

### Developing

Find the main and post action scripts in the `scripts` directory; 

The `install.sh` script in the same diretory is used to install wget, the hcloud cli and the post script into the container image. You can modify other internals of the image in the `Dockerfile`.

Please consult the `action.yml` for modifications of input variables or other meta and control information.

You can then build the image with 

``` bash
# From the git root diretory 
$ docker build -t hcloud-doorkeeper .
```

### Testing

* Update the [`env.example`](env.example) file to your desire
  > :warning: **To prevent accidental token leakage**, the API token should **not** be added to the environment file, but be declared on the commandline.
* Run the main action to create a firewall rule
  ```
  docker run --rm -it --env-file env.example --env HCLOUD_TOKEN=YOURTOKEN hcloud-doorkeeper
  ```
* Run the post action to delete the rule
  ```
  docker run --rm -it --env-file env.example --env HCLOUD_TOKEN=YOURTOKEN --entrypoint delete.sh hcloud-doorkeeper
  ``` 
* To start an interactive shell, use `docker run --rm -it --entrypoint bash hcloud-doorkeeper`
