class Subscription < ActiveRecord::Base

	Contact = Struct.new(:email, :phone)

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

end
