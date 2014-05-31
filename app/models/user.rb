class User < ActiveRecord::Base
	has_many :notifications

	attr_accessible :email, :phone_number


end
