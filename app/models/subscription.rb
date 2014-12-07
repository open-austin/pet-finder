class Subscription < ActiveRecord::Base

	validate :email_or_phone_is_required
	validates :email, :'validators/email' => true, if: :email?
	validates :phone, :'validators/phone' => true, if: :phone?

	def email_or_phone_is_required
    errors.add :base, "Email or phone are required." unless email? || phone?
	end

	Contact = Struct.new(:email, :phone)

	scope :confirmed, -> { where.not(confirmed_at: nil) }
	scope :unconfirmed, -> { where(confirmed_at: nil) }
	scope :maybe, ->(prop, value) { where(prop => [ value, nil, '' ]) }

	def contact
		@contact ||= Contact.new(email, phone)
	end

	def should_email?
		email?
	end

	def should_text?
		phone?
	end

	def confirmed?
		confirmed_at?
	end

	def confirm!
		self.confirmation_code = nil
		self.confirmed_at = Time.now
	end

	def as_params
		[:species, :gender, :found_since, :email, :phone].reduce({}) {|hash, current|
			hash[current] = self[current] unless self[current].blank?		
			hash
		}
	end

end