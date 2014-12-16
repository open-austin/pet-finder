class SMS

	def initialize(number, msg)
		@plivo = Plivo::RestAPI.new Figaro.env.plivo_auth_id, Figaro.env.plivo_auth_token
		@number = number.to_s
		# ensure we have a fully qualified number
		@number = "1#{@number}" if @number.length == 10
		@message = msg
	end

	def self.send(number, msg)
		self.new(number, msg).send
	end

	def send
		@plivo.send_message src: Figaro.env.plivo_number, dst: @number, text: @message
	end

end