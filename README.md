# gobgp-quagga
Vagrantfile with GoBGP and Quagga 

## Usage

```bash
# it may take a long time
vagrant up

# run gobgpd
vagrant ssh rt1
sudo -i
gobgpd -f ./shared/gobgp.toml

# open another window
vagrant ssh rt1
sudo -i
./scripts/create_namespaces.sh
gobgp global rib add 192.168.10.0/24`
```
