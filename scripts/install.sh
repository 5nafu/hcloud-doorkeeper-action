#!/bin/sh

# Install wget
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install --no-install-recommends wget ca-certificates
apt-get clean
rm -rf /var/lib/apt/lists/*

# Link Create to Cleanup script
ln -s /usr/local/bin/create.sh /usr/local/bin/delete.sh

# Get latest hcloud version from GitHub
API="https://api.github.com/repos/hetznercloud/cli/releases/latest"
HCLOUD_VERSION=$(wget -q -O- $API  | grep '"tag_name":'| cut -d'"' -f4)

if [[ -n "$TARGETOS" ]] || [[ -n "$TARGETARCH" ]]; then
    echo "target OS or ARCH unknown. uname shows:"
    uname -a
    echo "Using defaults: Linux & amd64"
fi

echo "Downloading version '$HCLOUD_VERSION' from GitHub..."
wget -O- https://github.com/hetznercloud/cli/releases/download/$HCLOUD_VERSION/hcloud-${TARGETOS:-linux}-${TARGETARCH:-amd64}.tar.gz | tar xzC /usr/local/bin hcloud