# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "fkrull/fedora28-atomic-workstation"

  config.vm.provision "shell", inline: <<-EOF
    systemctl enable --now docker
  EOF
end
