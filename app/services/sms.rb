class SMS

	def initialize(number, msg)
		@plivo = Plivo::RestAPI.new Figaro.env.plivo_auth_id, Figaro.env.plivo_auth_token
		@number = number.to_s
		@message = msg
	end

	def self.send(number, msg)
		self.new(number, msg).send
	end

	def send
		@plivo.send_message src: Figaro.env.plivo_number, dst: @number, text: @message
	end

end