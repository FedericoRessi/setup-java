# -*- mode: ruby -*-
# vi: set ft=ruby :

# --- VMs configuration -------------------------------------------------------

# number of CPUs for every VM
vm_cpus = 1

# megabytes of RAM for every VM
vm_memory = 1024

# available VM images
vm_images = [
  ["precise", "ubuntu/precise64"],
  ["trusty", "ubuntu/trusty64"],
  ["fedora23", "box-cutter/fedora23"],
  ["centos7", "puppetlabs/centos-7.2-64-nocm"]]

vm_provision_script = "scripts/provision.sh"

vm_provision_args = ""

http_proxy = ENV["http_proxy"]
https_proxy = ENV["https_proxy"]
no_proxy = ENV["no_proxy"]

# --- vagrant meal ------------------------------------------------------------

Vagrant.configure(2) do |config|

  # For every available VM image
  vm_images.each do |vm_name, vm_image|

    config.vm.define vm_name do |conf|
      conf.vm.box = vm_image
      # conf.vm.hostname = vm_name

      # assign a different random port to every vm instance
      # this avoid concurrency problems when running tests in parallel
      conf.vm.network :forwarded_port, guest: 22, host: 22000 + rand(9999),
        id: "ssh", auto_correct: true
    end
  end

  # Specific VirtualBox paramters
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = vm_memory
    vb.cpus = vm_cpus
  end

  # Configure proxy
  if Vagrant.has_plugin?("vagrant-proxyconf")
    if http_proxy != nil
       config.proxy.http = http_proxy
    end
    if https_proxy != nil
       config.proxy.https = https_proxy
    end
    if no_proxy != nil
      config.proxy.no_proxy = no_proxy
    end
  end

  # Provision project script
  config.vm.provision "shell" do |script|
    script.path = vm_provision_script
    script.args = vm_provision_args
  end

end
