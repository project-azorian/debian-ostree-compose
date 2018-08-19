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
    set -eux
    pip3 install "https://gitlab.com/fkrull/deploy-ostree/-/jobs/artifacts/master/raw/dist/deploy_ostree-1.0.0-py3-none-any.whl?job=build-wheel"

    ostree init --repo=/home/vagrant/ostree-build
    ostree init --repo=/home/vagrant/ostree-publish --mode=archive

    docker run -d \
      --restart=always \
      --name http \
      -v /home/vagrant/ostree-publish:/usr/share/nginx/html:ro \
      -p 8000:80 \
      nginx:1-alpine
  SHELL
end
