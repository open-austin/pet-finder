[ :http_username, :http_password, :aws_key, :aws_secret, :s3_bucket ].each do |req|
	raise StandardError.new("You must set #{req.to_s} in the ENV") unless Figaro.env.respond_to? req
end