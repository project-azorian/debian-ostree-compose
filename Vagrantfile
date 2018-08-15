# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "fedora/28-atomic-host"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = 2048
    vb.gui = true
  end

  config.vm.provision :shell, inline: <<-SHELL
    pip3 install https://gitlab.com/fkrull/deploy-ostree/-/archive/master/deploy-ostree-master.tar.bz2
  SHELL
end
