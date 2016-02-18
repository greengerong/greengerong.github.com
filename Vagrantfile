# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64" #"puphpet/centos65-x64"

  config.vm.define "blog-vm" do |cfg|
  	  cfg.vm.host_name = "blog.vm"
	  cfg.vm.network :private_network, ip: "192.168.100.2" 
	  config.vm.network :forwarded_port, guest: 4000, host: 4000
	  cfg.ssh.forward_agent = true

	  cfg.vm.provision "ansible" do |ansible|
	    ansible.playbook = "provision/playbook.yml"
	    ansible.verbose = 'v'
	  end

  end

end
