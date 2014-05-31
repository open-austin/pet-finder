class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :search

	attr_accessible :type

end
