# -*- mode: ruby -*-
# vi: set ft=ruby :
#
VAULT_VERSION="1.1.0"
JQ_VERSION="1.6"

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.provision :shell, inline: "setenforce 0", run: "always"
  config.vm.provision "shell", inline: <<-SHELL
     yum install -y docker unzip net-tools
     curl -o /tmp/vault.zip https://releases.hashicorp.com/vault/#{VAULT_VERSION}/vault_#{VAULT_VERSION}_linux_amd64.zip &&  unzip -d /usr/local/bin/ /tmp/vault.zip
     curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-#{JQ_VERSION}/jq-linux64 && chmod 0755 /usr/local/bin/jq
     groupadd docker
     usermod -aG docker vagrant
     systemctl start docker
  SHELL
end
