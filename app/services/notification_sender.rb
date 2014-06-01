class NotificationSender

	def initialize(subscriptions)
		@subscriptions = subscriptions
	end

	def self.matching(result)
		subscriptions = Subscription
			.maybe(:species, result.species)
			.maybe(:gender, result.gender)
			.maybe(:fixed, result.fixed)
			.maybe(:color, result.color)
		
		new(subscriptions)
	end

	def send_all
		send_emails
		send_texts
	end

	def send_emails
		@subscriptions.each do |subscription|
			send_email(subscription) if subscription.should_email?
		end
	end

	def send_texts
		@subscriptions.each do |subscription|
			send_text(subscription) if subscription.should_text?
		end
	end

	private

	def send_email(subscription)
		NotificationMailer.notify_email(subscription.contact).deliver
	end

	def send_text(subscription)
		uri = URI.parse("https://api.plivo.com/v1/Account/#{ENV['PLIVO_AUTH_ID']}/Message/")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(ENV['PLIVO_AUTH_ID'],ENV['PLIVO_AUTH_TOKEN'])
    
		request.set_form_data({"src" => ENV['PLIVO_NUMBER'], "dst" => subscription.contact.phone, "text" => "New Pet Found! (via PetFinder app)"})
    response = http.request(request)
	end

end