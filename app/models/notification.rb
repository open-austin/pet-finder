class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :search

	def send
		send_email if user.email.present?
		send_text if user.phone_number.present?
	end

	private

	def send_welcome_email
		NotificationMailer.welcome_email(user).deliver
	end

	def send_notify_email
		NotificationMailer.notify_email(user).deliver
	end

	def send_text
		uri = URI.parse("https://api.plivo.com/v1/Account/#{ENV['PLIVO_AUTH_ID']}/Message/")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(ENV['PLIVO_AUTH_ID'],ENV['PLIVO_AUTH_TOKEN'])
    
		request.set_form_data({"src" => ENV['PLIVO_NUMBER'], "dst" => user.phone_number, "text" => "New Pet Found! (via PetFinder app)"})
    response = http.request(request)
	end

end
