class NotificationSender

	def initialize(notifications)
		@notifications = notifications
	end

	def self.matching(result)
		notifications = Notification
			.maybe(:species, result.species)
			.maybe(:gender, result.gender)
			.maybe(:fixed, result.fixed)
			.maybe(:color, result.color)
		
		new(notifications)
	end

	def send_all
		send_emails
		send_texts
	end

	def send_emails
		@notifications.each do |notification|
			send_email(notification) if notification.should_email?
		end
	end

	def send_texts
		@notifications.each do |notification|
			send_text(notification) if notification.should_text?
		end
	end

	private

	def send_email(notification)
		NotificationMailer.notify_email(notification.contact).deliver
	end

	def send_text(notification)
		uri = URI.parse("https://api.plivo.com/v1/Account/#{ENV['PLIVO_AUTH_ID']}/Message/")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(ENV['PLIVO_AUTH_ID'],ENV['PLIVO_AUTH_TOKEN'])
    
		request.set_form_data({"src" => ENV['PLIVO_NUMBER'], "dst" => notification.contact.phone, "text" => "New Pet Found! (via PetFinder app)"})
    response = http.request(request)
	end

end