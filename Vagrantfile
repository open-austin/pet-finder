# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT

log() { echo $'\n'VAGRANTFILE: $@...$'\n'; }

log Base level stuff
apt-get update
apt-get -y install curl
apt-get -y install git # necessary for installing the data feeder

log Installing database
apt-get install sqlite3 libsqlite3-dev

log Installing RVM
curl -sSL https://get.rvm.io | bash -s stable
source /usr/local/rvm/scripts/rvm
rvm requirements

log Installing Ruby
rvm install ruby-2.1.0
rvm use ruby-2.1.0 --default

log Installing app dependencies
cd /vagrant
gem install bundler -v '= 1.5.1' # this is necessary to successfully bundle install, otherwise it stumbles on json gem
bundle install --path=vendor --without production

log Building database
bin/rake db:migrate

log Starting Rails server
bin/rails s -d

log Running the data feeder
cd ~
git clone https://github.com/tshelburne/aac-pets-feed.git data-feeder
cd data-feeder
bundle install --path=vendor
ruby scrape.rb --env development

log Setting up some conveniences
echo "cd /vagrant" >> /home/vagrant/.bashrc
rvm rvmrc warning ignore /vagrant/Gemfile

SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "precise32"
	config.vm.box_url = "http://files.vagrantup.com/precise32.box"
 #  config.vm.network :private_network, ip: '192.168.50.50'
	config.vm.synced_folder ".", "/vagrant", type: 'rsync'
	config.vm.network :forwarded_port, guest: 3000, host: 3000
  # config.vm.network :forwarded_port, guest: 443, host: 4430
  config.vm.provision 'shell', inline: $script
  
  # thanks to http://www.stefanwrobel.com/how-to-make-vagrant-performance-not-suck
  config.vm.provider "virtualbox" do |v|
    host = RbConfig::CONFIG['host_os']

    # Give VM 1/4 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # sorry Windows folks, I can't help you
      cpus = 2
      mem = 1024
    end

    v.customize ["modifyvm", :id, "--memory", mem]
    v.customize ["modifyvm", :id, "--cpus", cpus]
  end
end
