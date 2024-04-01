# This module is part of course Terraform and Microstack (only for demo & development purpose)

This module creates second "external" network type on [microstack](https://snapcraft.io/microstack).

## Requirements

Microstack installed on the host machine.
You should run the following script to create the management bridge on the host machine.

## Variables

- manag_bridge_name : Name of the management bridge
- managcidr : CIDR of the management bridge (it will be used for the IP address of the bridge)
- physnet_name : Name of the physical network



```bash
#!/bin/bash
#
# original script used for creating external bridge and adapted to create a management bridge 
# source : https://opendev.org/x/microstack/src/branch/master/snap-overlay/bin/setup-br-ex

set -ex

if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run with sudo' >&2
        exit 1
fi

## Default values https://opendev.org/x/microstack/src/branch/master/snap-overlay/bin/set-default-config.py
default_bridge_name="br-ex"
default_physnet_name="physnet1"

# Management bridge values
manag_bridge_name="br-ma"
managcidr="172.16.1.1/24"
physnet_name=physnet2


# Create an external bridge in the system datapath.

echo "Creating bridge $manag_bridge_name"
microstack.ovs-vsctl --retry --may-exist add-br $manag_bridge_name -- set bridge $manag_bridge_name datapath_type=system protocols=OpenFlow13,OpenFlow15
echo "Adding $manag_bridge_name to $physnet_name"
microstack.ovs-vsctl set open . external-ids:ovn-bridge-mappings=$default_physnet_name:$default_bridge_name,$physnet_name:$manag_bridge_name

# NOTE: system-id is a randomly-generated UUID (see the --system-id=random option for ovs-ctl)
# As it is generated automatically, we do not set it here.
# It can be retrieved by looking at `ovs-vsctl get open_vswitch . external-ids`.

# Configure br-ma
echo "Configuring $manag_bridge_name"
ip address add $managcidr dev br-ma || :
echo "Setting $manag_bridge_name up"
ip link set br-ma up || :

# Post routing already done for external bridge at microstack init
iptables-legacy -w -t nat -A POSTROUTING -s $managcidr ! \
     -d $managcidr -j MASQUERADE || :

# Just ensure that the kernel is set up to forward packets
sysctl net.ipv4.ip_forward=1

exit 0
```


## Usage

```terraform

