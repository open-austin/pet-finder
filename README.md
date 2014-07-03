Pet Alert
==========

Part of [ATX Hack for Change 2014](http://atxhackforchange.org/)

**Problem:** Currently, real-time online information on lost / found pets is difficult to find and use, prolonging pet and owner separation and taking up valuable shelter space in Austin, a no-kill city.

**Project:** Create a tool that periodically scrapes pet recovery postings and saves them to a database that can be searched via a web tool and will push notifications to interested parties.

## Details

[Pet Harbor](http://www.petharbor.com/) is the sole datasource of the app as of now - we are retrieving data by performing regular scrapes of the site for new found animals, and running constant reconciliations with our database. The scraper is not part of the Rails application (this repository) - instead, the Rails app has an [API](app/controllers/pet_populator_controller.rb) that provides access to update our database of missing animals, and external scripts are handling the *nasty* business of scraping external sources. The current [Pet Harbor scraper](https://github.com/whgest/HereKittyScraper) is a Python script using [Scrapy](http://scrapy.org/) to scrape and parse the data.

Notifications are being sent to subscribers via email and text message for any new animals logged on Pet Harbor. 

## Contributing

To contribute, fork this repo and submit pull requests for merges. All updates should have accompanying tests (we use [RSpec](https://relishapp.com/rspec/rspec-core/v/2-14/docs)), and should ensure that all existing tests are passing. We are still establishing coding standards and practices, so do your best to contribute code that is as consistent as possible with things now.