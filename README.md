# gobgp-quagga
Vagrantfile with GoBGP and Quagga 

## Usage

### common

```bash
# it may take a long time
vagrant up
```

### rt1

```
vagrant ssh rt1
sudo -i

./scripts/create_namespaces.sh
gobgp global rib add 192.168.10.0/24

ip netns exec host1-1 bash
```

### rt2

```
vagrant ssh rt2
sudo -i

./scripts/create_namespaces.sh
gobgp global rib add 192.168.20.0/24

ip netns exec host2-1 bash
```

### rt3

```
vagrant ssh rt3
sudo -i
./scripts/create_namespaces.sh
gobgp global rib add 192.168.30.0/24

ip netns exec host3-1 bash
```
