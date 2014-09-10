# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT

log() { echo $'\n'VAGRANTFILE: $@...$'\n'; }

log Base level stuff
apt-get update
apt-get -y install curl

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

log Building database...
bin/rake db:migrate

log Starting Rails server
bin/rails s -d

log Setting up some conveniences
echo "cd /vagrant" >> /home/vagrant/.bashrc
rvm rvmrc warning ignore /vagrant/Gemfile

SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  # config.vm.network :forwarded_port, guest: 443, host: 4430
  config.vm.provision 'shell', inline: $script
end
