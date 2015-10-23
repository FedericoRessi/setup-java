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
    ["ubuntu1404", "ubuntu/trusty64"],
    ["ubuntu1504", "ubuntu/vivid64"],
    ["fedora21", "box-cutter/fedora21"],
    ["fedora22", "box-cutter/fedora22"],
    ["centos7", "puppetlabs/centos-7.0-64-nocm"]]

  boxes.each do |name, box|
    config.vm.define name do |c|
      c.vm.box = box
      c.vm.network :forwarded_port, guest: 22, host: 20000 + rand(10000),
        id: "ssh", auto_correct: true
      c.vm.network :forwarded_port, guest: 80, host: 8000 + rand(5000),
        id: "ssh", auto_correct: true
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

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 512
    vb.cpus = 1
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :machine
    config.cache.enable :pip
    config.cache.enable :yum
    config.cache.enable :apt
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    #!/bin/bash -xe

    set -ex

    if apt-get --version; then
      apt-get update -y
      apt-get install -y git realpath
      function is_ubuntu {
        return 0
      }

    elif dnf --version; then
      dnf install -y git
      function is_ubuntu {
        return 1
      }

    elif yum --version; then
      yum install -y git
      function is_ubuntu {
        return 1
      }

    fi

    cd /vagrant

    if ! cd networking-odl; then
        git clone http://git.openstack.org/openstack/networking-odl -b master
        cd networking-odl
        git fetch http://review.openstack.org/openstack/networking-odl refs/changes/10/218210/18
        git rebase origin/master FETCH_HEAD
        git checkout -b bug/1467949
    fi

    source devstack/setup_java.sh

    for VERSION in 7 8; do
      setup_java $VERSION 
      test_java_version java $VERSION
      [[ "$JAVA" == "$(realpath $(which java))" ]]
      find "$JAVA_HOME" -name java | grep "$JAVA"
      [[ "$(basename $JAVA_HOME)" != "jre" ]]
    done

  SHELL
end
