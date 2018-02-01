#!/bin/sh

apt-get update
apt-get upgrade -y
apt-get install -y build-essential traceroute

# download go
wget https://dl.google.com/go/go1.9.3.linux-amd64.tar.gz 2>/dev/null
sudo tar -C /usr/local -xzf go1.9.3.linux-amd64.tar.gz
echo 'export GOROOT=/usr/local/go' >> $HOME/.bashrc
echo 'export GOPATH=$HOME/.golang' >> $HOME/.bashrc
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> $HOME/.bashrc

# download gobgp
export GOROOT=/usr/local/go
export GOPATH=/root/.golang
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

go get github.com/osrg/gobgp/gobgpd
go get github.com/osrg/gobgp/gobgp

wget https://raw.githubusercontent.com/osrg/gobgp/master/tools/completion/gobgp-completion.bash -P /root 2>/dev/null
wget https://raw.githubusercontent.com/osrg/gobgp/master/tools/completion/gobgp-static-completion.bash -P /root 2>/dev/null
wget https://raw.githubusercontent.com/osrg/gobgp/master/tools/completion/gobgp-dynamic-completion.bash -P /root 2>/dev/null

echo 'source $HOME/gobgp-completion.bash' >> $HOME/.bashrc
