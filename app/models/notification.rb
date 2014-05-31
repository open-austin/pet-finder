class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :search

	attr_accessible :type

	def send_email
	end

	def send_text
	end

end
