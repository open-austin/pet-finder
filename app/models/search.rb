class Search < ActiveRecord::Base
	has_many :notifications

	attr_accessible :species, :gender, :fixed, :color, :breed, :found_on
end
