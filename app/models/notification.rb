class Notification < ActiveRecord::Base

	Contact = Struct.new(:email, :phone)

	attr_accessible :email, :phone, :species, :gender, :fixed, :found_since, :color

	scope :maybe, ->(prop, value) { where(prop => [ value, nil ]) }

	def contact
		@contact ||= Contact.new(email, phone)
	end

	def send_notification
		send_notify_email if contact.email.present?
		send_text if contact.phone.present?
	end

	private

	def send_welcome_email
		NotificationMailer.welcome_email(contact).deliver
	end

	def send_notify_email
		NotificationMailer.notify_email(contact).deliver
	end

	def send_text
		uri = URI.parse("https://api.plivo.com/v1/Account/#{ENV['PLIVO_AUTH_ID']}/Message/")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(ENV['PLIVO_AUTH_ID'],ENV['PLIVO_AUTH_TOKEN'])
    
		request.set_form_data({"src" => ENV['PLIVO_NUMBER'], "dst" => contact.phone, "text" => "New Pet Found! (via PetFinder app)"})
    response = http.request(request)
	end

end
