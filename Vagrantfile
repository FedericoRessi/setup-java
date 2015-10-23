# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  boxes = [
    ["trusty", "ubuntu/trusty64"],
    ["vivid", "ubuntu/vivid64"],
    ["fedora21", "box-cutter/fedora21"],
    ["fedora22", "box-cutter/fedora22"],
    ["centos7", "puppetlabs/centos-7.0-64-nocm"]]

  boxes.each do |name, box|
    config.vm.define name do |c|
      c.vm.box = box
      c.vm.network :forwarded_port, guest: 22, host: 20000 + rand(10000),
        id: "ssh", auto_correct: true
      c.vm.network :forwarded_port, guest: 80, host: 8000 + rand(5000),
        id: "http", auto_correct: true
    end
  end
 
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 512
    vb.cpus = 1
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

end
