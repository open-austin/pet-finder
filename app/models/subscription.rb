class Subscription < ActiveRecord::Base

	Contact = Struct.new(:email, :phone)

	attr_accessible :email, :phone, :species, :gender, :fixed, :found_since, :color

	scope :maybe, ->(prop, value) { where(prop => [ value, nil ]) }

	def contact
		@contact ||= Contact.new(email, phone)
	end

	def should_email?
		email.present?
	end

	def should_text?
		phone.present?
	end

	private

	def send_welcome_email
		NotificationMailer.welcome_email(contact).deliver
	end

end
