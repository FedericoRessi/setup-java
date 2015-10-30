# -*- mode: ruby -*-
# vi: set ft=ruby :

# --- VMs configuration -------------------------------------------------------

# number of CPUs for every VM
vm_cpus = 1

# megabytes of RAM for every VM
vm_memory = 1024

# available VM images
vm_images = [
  ["trusty", "ubuntu/trusty64"],
  ["vivid", "ubuntu/vivid64"],
  ["fedora21", "box-cutter/fedora21"],
  ["fedora22", "box-cutter/fedora22"],
  ["centos7", "puppetlabs/centos-7.0-64-nocm"]]

vm_provision_script = "scripts/provision.sh"

vm_provision_args = ""

# --- vagrant meal ------------------------------------------------------------

Vagrant.configure(2) do |config|

  # For every available VM image
  vm_images.each do |vm_name, vm_image|

    config.vm.define vm_name do |conf|
      conf.vm.box = vm_image
      conf.vm.hostname = vm_name

      # assign a different random port to every vm instance
      # this avoid concurrency problems when running tests in parallel
      conf.vm.network :forwarded_port, guest: 22, host: 22000 + rand(1000),
        id: "ssh", auto_correct: true
      conf.vm.network :forwarded_port, guest: 80, host: 8000 + rand(1000),
        id: "http", auto_correct: true
    end
  end

  # Specific VirtualBox paramters
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = vm_memory
    vb.cpus = vm_cpus
  end

  # Provision project script
  config.vm.provision "shell" do |script|
    script.path = vm_provision_script
    script.args = vm_provision_args
  end

end
