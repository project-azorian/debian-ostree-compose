# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "build" do |config|
    config.vm.box = "bento/debian-9"
    config.vm.network :private_network, ip: "192.168.60.10"

    config.vm.provider :virtualbox do |vb|
      vb.cpus = 2
      vb.memory = 2048
    end

    config.vm.provision :shell, inline: <<-SHELL
      set -eux
      apt-get update
      apt-get install -y ostree

      ostree init --repo=/home/vagrant/ostree-publish --mode=archive
    SHELL

    config.vm.provision :docker do |d|
      d.run "http", image: "nginx:1-alpine", args: [
        "-p 8000:80",
        "-v /home/vagrant/ostree-publish:/usr/share/nginx/html/ostree:ro",
        "-v /vagrant/deploy:/usr/share/nginx/html/deploy:ro",
    ].join(" ")
    end

    config.vm.provision :shell, run: :always, inline: "docker restart http"
  end

  config.vm.define "deploy" do |config|
    config.vm.box = "fedora/prerelease-29-atomic-host"
    config.vm.network :private_network, type: :dhcp

    config.vm.provider :virtualbox do |vb|
      vb.cpus = 2
      vb.memory = 2048
      vb.gui = true
      vb.customize ["modifyvm", :id, "--vram", 256]
    end

    config.vm.provision :shell, inline: <<-SHELL
      set -eux
      rpm-ostree install git
      rpm-ostree ex livefs
      pip3 install git+https://github.com/project-azorian/deploy-ostree.git@yaml-input
    SHELL
  end
end
