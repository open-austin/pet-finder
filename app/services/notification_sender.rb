class NotificationSender
	include Rails.application.routes.url_helpers

	def initialize(subscriptions, pet)
		@subscriptions = subscriptions
		@pet = pet
	end

	def self.matching(pet)
		subscriptions = Subscription
			.confirmed
			.where(species: pet.species)
			.maybe(:gender, pet.gender)
			.maybe(:color, pet.color)
		
		new(subscriptions, pet)
	end

	def send_all
		send_emails
		send_texts
	end

	def send_emails
		@subscriptions.select(&:should_email?).each {|subscription| send_email(subscription)}
	end

	def send_texts
		@subscriptions.select(&:should_text?).each {|subscription| send_text(subscription)}
	end

	private

	def send_email(subscription)
		NotificationMailer.notification_email(subscription, @pet).deliver
	end

	def send_text(subscription)
		SMS.send subscription.contact.phone, "We found a new match on PetAlerts: #{show_url @pet}"
	end

end