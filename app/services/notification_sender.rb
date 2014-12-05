class NotificationSender

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
		uri = URI.parse("https://api.plivo.com/v1/Account/#{ENV['PLIVO_AUTH_ID']}/Message/")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(ENV['PLIVO_AUTH_ID'],ENV['PLIVO_AUTH_TOKEN'])
    
		request.set_form_data({"src" => ENV['PLIVO_NUMBER'], "dst" => subscription.contact.phone, "text" => "New Pet Found! (via PetAlerts app)"})
    response = http.request(request)
	end

end