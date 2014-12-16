class Subscription < ActiveRecord::Base

	validate :email_or_phone_is_required
	validates :email, :'validators/email' => true, if: :email?
	validates :phone, :'validators/phone' => true, if: :phone?

	def email_or_phone_is_required
    errors.add :base, "Email or phone is required." unless email? || phone?
	end

	scope :confirmed, -> { where.not(confirmed_at: nil) }
	scope :unconfirmed, -> { where(confirmed_at: nil) }
	scope :maybe, ->(prop, value) { where(prop => [ value, nil, '' ]) }

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