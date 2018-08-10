# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install Required Vagrant Plugins
required_plugins = ['vagrant-hostmanager']
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = false

  # Host Manager Settings
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  # VMs definition

  # Prov VM
  config.vm.define "kino" do |kino|
    kino.vm.hostname = "kino.dev"
    kino.vm.network "private_network", ip: "192.168.0.200"
    kino.vm.provider "virtualbox" do |vb|
      vb.name = "kino_dev"
      vb.memory = "4096"
    end
    kino.vm.provision "shell", path: "build-kino.sh", args: "manager"
  end

end
