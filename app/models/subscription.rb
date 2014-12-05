class Subscription < ActiveRecord::Base

	Contact = Struct.new(:email, :phone)

	scope :confirmed, -> { where.not(confirmed_at: nil) }
	scope :unconfirmed, -> { where(confirmed_at: nil) }
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

	def confirmed?
		confirmed_at.present?
	end

	def confirm!
		self.confirmed_at = Time.now
	end

end
