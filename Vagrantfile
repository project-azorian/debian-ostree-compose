# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "build" do |config|
    config.vm.box = "bento/debian-9"
    config.vm.provider :virtualbox do |vb|
      vb.cpus = 2
      vb.memory = 2048
    end

    config.vm.provision :shell, inline: <<-SHELL
      set -eux
      apt-get update
      apt-get install -y ostree

      ostree init --repo=/home/vagrant/ostree-build
      ostree init --repo=/home/vagrant/ostree-publish --mode=archive
    SHELL

    config.vm.provision :docker do |d|
      d.run "http", image: "nginx:1-alpine", args: [
        "-p 8000:80",
        "-v /home/vagrant/ostree-publish:/usr/share/nginx/html:ro",
    ].join(" ")
    end
  end

  config.vm.define "deploy" do |config|
    config.vm.box = "fedora/28-atomic-host"
    config.vm.provider :virtualbox do |vb|
      vb.gui = true
    end

    config.vm.provision :shell, inline: <<-SHELL
      set -eux
      pip3 install "https://gitlab.com/fkrull/deploy-ostree/-/jobs/artifacts/master/raw/dist/deploy_ostree-1.0.0-py3-none-any.whl?job=build-wheel"
    SHELL
  end
end
