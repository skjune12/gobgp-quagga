#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then
    echo "Error: Please run with sudo";
    exit 1;
fi

set -e

run () {
    echo "$@"
    "$@" || exit 1
}

HOSTNUM=$(echo `hostname` | rev | cut -c 1)

create_network() {
    run ip netns add host${1}-1
    run ip netns add host${1}-2

    # create veth pair of rt${HOSTNUM} and host${HOSTNUM}-1
    run ip link add name rt${1}_host${1}-1 type veth peer name host${1}-1_rt${1}
    run ip link set host${1}-1_rt${1} netns host${1}-1

    # create veth pair of rt${HOSTNUM} and host${HOSTNUM}-2
    run ip link add name rt${1}_host${1}-2 type veth peer name host${1}-2_rt${1}
    run ip link set host${1}-2_rt${1} netns host${1}-2

    # default namespace configuration
    run ip link add hostbr0 type bridge
    run ip link set hostbr0 up

    run ip link set dev rt${1}_host${1}-1 up
    run ip link set dev rt${1}_host${1}-1 master hostbr0

    run ip link set dev rt${1}_host${1}-2 up
    run ip link set dev rt${1}_host${1}-2 master hostbr0
    run ip addr add 192.168.${1}0.1/24 dev hostbr0
    run /sbin/sysctl -w net.ipv4.ip_forward=1

    # host ${1}-1 configuration
    run ip netns exec host${1}-1 ip link set lo up
    run ip netns exec host${1}-1 ip link set host${1}-1_rt${1} up
    run ip netns exec host${1}-1 ip addr add 192.168.${1}0.10/24 dev host${1}-1_rt${1}
    run ip netns exec host${1}-1 ip route add default via 192.168.${1}0.1

    # host ${1}-2 configuration
    run ip netns exec host${1}-2 ip link set lo up
    run ip netns exec host${1}-2 ip link set host${1}-2_rt${1} up
    run ip netns exec host${1}-2 ip addr add 192.168.${1}0.20/24 dev host${1}-2_rt${1}
    run ip netns exec host${1}-2 ip route add default via 192.168.${1}0.1
}

destroy_network () {
    run ip netns del host${1}-1
    run ip netns del host${1}-2
    run ip link delete hostbr0 type bridge
    run /sbin/sysctl -w net.ipv4.ip_forward=0
}

stop () {
    destroy_network $HOSTNUM
}

create_network $HOSTNUM

cat <<EOF
-----
Created Virtual Network successfully
-----
EOF

trap stop 0 1 2 3 13 14 15

status=0; $SHELL || status=$?

cat <<EOF
-----
Cleaned Virtual Network successfully
-----
EOF

exit $status
