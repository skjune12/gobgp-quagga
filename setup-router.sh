#!/bin/sh

echo "Install Dependencies"
apt-get update -qq
apt-get upgrade -qq -y
apt-get install -qq -y \
    build-essential \
    quagga \
    traceroute \
    mtr \
    bridge-utils

# download go
echo "Download Go"
wget https://dl.google.com/go/go1.9.3.linux-amd64.tar.gz 2>/dev/null
sudo tar -C /usr/local -xzf go1.9.3.linux-amd64.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bashrc
echo 'export GOPATH=$HOME/.golang' >> $HOME/.bashrc
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> $HOME/.bashrc

# download gobgp
echo "Download GoBGP"
export GOROOT=/usr/local/go
export GOPATH=/root/.golang
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

go get github.com/osrg/gobgp/gobgpd
go get github.com/osrg/gobgp/gobgp

# create /etc/systemd/system/gobgpd.service
cat << EOF > /etc/systemd/system/gobgpd.service
[Unit]
Description=gobgpd
After=network.target syslog.target

[Service]
Type=simple
PermissionsStartOnly=yes
User=root
ExecStartPre=/sbin/setcap 'cap_net_bind_service=+ep' /root/.golang/bin/gobgpd
ExecStart=/root/.golang/bin/gobgpd -f /root/shared/gobgp.toml
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart gobgpd
systemctl enable gobgpd

# configure zebra
echo "Configure zebra (quagga)"
sed -i 's/zebra=no/zebra=yes/g' /etc/quagga/daemons
sed -i 's/bgpd=no/bgpd=yes/g' /etc/quagga/daemons   # not needed?
cp /usr/share/doc/quagga/examples/zebra.conf.sample /etc/quagga/zebra.conf
systemctl restart quagga

echo "Install gobgp-completion.bash"
wget https://raw.githubusercontent.com/osrg/gobgp/master/tools/completion/gobgp-completion.bash -P /root 2>/dev/null
wget https://raw.githubusercontent.com/osrg/gobgp/master/tools/completion/gobgp-static-completion.bash -P /root 2>/dev/null
wget https://raw.githubusercontent.com/osrg/gobgp/master/tools/completion/gobgp-dynamic-completion.bash -P /root 2>/dev/null

echo 'source $HOME/gobgp-completion.bash' >> $HOME/.bashrc
