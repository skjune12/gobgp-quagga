# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # router1
  config.vm.define :rt1 do |server|
    server.vm.box = "ubuntu/xenial64"
    server.vm.hostname = "rt1"

    server.vm.network "private_network", ip: "10.10.0.1", netmask: "255.255.255.0", virtualbox__intnet: "gobgp"

    # run setup script
    server.vm.provision "shell", privileged: true, path: "setup-vm.sh"

    server.vm.synced_folder "./shared/rt1", "/root/shared"
    server.vm.synced_folder "./shared/scripts", "/root/scripts"
  end

  # router2
  config.vm.define :rt2 do |server|
    server.vm.box = "ubuntu/xenial64"
    server.vm.hostname = "rt2"

    server.vm.network "private_network", ip: "10.10.0.2", netmask: "255.255.255.0", virtualbox__intnet: "gobgp"

    # run setup script
    server.vm.provision "shell", privileged: true, path: "setup-vm.sh"

    server.vm.synced_folder "./shared/rt2", "/root/shared"
    server.vm.synced_folder "./shared/scripts", "/root/scripts"
  end

  # router3
  config.vm.define :rt3 do |server|
    server.vm.box = "ubuntu/xenial64"
    server.vm.hostname = "rt3"

    # for outside network
    server.vm.network "private_network", ip: "10.10.0.3", netmask: "255.255.255.0", virtualbox__intnet: "gobgp"

    # run setup script
    server.vm.provision "shell", privileged: true, path: "setup-vm.sh"

    server.vm.synced_folder "./shared/rt3", "/root/shared"
    server.vm.synced_folder "./shared/scripts", "/root/scripts"
  end

end
