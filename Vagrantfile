# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'hashicorp/precise32'
  config.vm.network 'forwarded_port', guest: 5000, host: 5000
  config.vm.network 'private_network', ip: '10.0.50.50'
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end
  config.ssh.forward_agent = true
  config.vm.provision 'shell', path: 'vagrant_privileged.sh', privileged: true
  config.vm.provision 'shell', path: 'vagrant.sh', privileged: false
end
