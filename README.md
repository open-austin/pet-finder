Pet Alerts
==========

Part of [ATX Hack for Change 2014](http://atxhackforchange.org/)

**Problem:** Currently, real-time online information on lost / found pets is difficult to find and use, prolonging pet and owner separation and taking up valuable shelter space in Austin, a no-kill city.

**Project:** Create a tool that periodically scrapes pet recovery postings and saves them to a database that can be searched via a web tool and will push notifications to interested parties.

## Details

[Pet Harbor](http://www.petharbor.com/) and the [Austin Animal Center](https://data.austintexas.gov/Government/Austin-Animal-Center-Stray-Map/kz4x-q9k5) are the sole datasources of the app as of now - we are retrieving data by performing regular API requests against the Austin data portal for new found animals, and running constant reconciliations with our database. The feeder is not part of the Rails application (this repository) - instead, the Rails app has an [API](app/controllers/pet_populator_controller.rb) that provides access to update our database of missing animals, and external scripts are handling the *nasty* business of scraping external sources. The current [Pet Harbor feeder](https://github.com/tshelburne/aac-pets-feed) is a Ruby script using [soda](https://github.com/socrata/soda-ruby) to access the data.

Notifications are being sent to subscribers via email and text message for any new animals logged on AAC. 

## Installation

**NOTE: We temporarily discourage the use of vagrant for this project - it's too slow to be feasible.**

### Local

1. Make sure you have Ruby 2.1.3 installed (RVM or rubyenv make this easy)
1. Make sure you have Bundler installed
1. `$ git clone git@github.com:open-austin/pet-finder.git`
1. `$ bundle install`
1. `$ rake db:migrate`
1. `$ rails server`
1. Visit [localhost:3000](http://localhost:3000) to view the site in the browser.

### Vagrant

1. Make sure you have [VirtualBox](https://www.virtualbox.org/) installed.
1. Make sure you have [vagrant](https://docs.vagrantup.com) installed.
1. `$ git clone git@github.com:open-austin/pet-finder.git`
1. `$ vagrant up`
	- Note that you will likely have to enter your password at some point to enable NFS - this is bypassable by `source`ing the following from [vagrant's docs](https://docs.vagrantup.com/v2/synced-folders/nfs.html):

			Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
			Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
			Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
			%admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE

1. Visit [localhost:3000](http://localhost:3000) to view the site in the browser.

### Configuration

We are using Figaro to manage secret configuration settings - all this means for you is that you should create an application.yml file in config/ that looks like the following:

```
GMAIL_USERNAME: [working gmail address]
GMAIL_PASSWORD: [working gmail password]

http_username: username
http_password: password

aws_key: [request a key]
aws_secret: [request a secret]
s3_bucket: pet-alert-dev

plivo_auth_id: auth-id
plivo_auth_token: auth-token
plivo_number: 1231231234
```

### Email services

All emails are sent from a background service called Sidekiq that will be installed alongside the rest of the gems - however, Sidekiq requires redis in order to function properly. 

1. Install redis
1. `$ redis-server`
1. `$ bundle exec sidekiq -q notifier -q default`

### SMS services

We are using Plivo to send SMS messages - if you need to test this locally, you will need to request an auth id and token from us. Generally, this shouldn't be necessary - the message sending part of the app is taken care of.

## Contributing

To contribute, fork this repo and submit pull requests for merges. All updates should have accompanying tests (we use [RSpec](https://relishapp.com/rspec/rspec-core/v/2-14/docs)), and should ensure that all existing tests are passing. We are still establishing coding standards and practices, so do your best to contribute code that is as consistent as possible with things now.