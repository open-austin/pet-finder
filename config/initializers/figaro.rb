[ 
	:http_username, 
	:http_password, 
	:aws_key, 
	:aws_secret, 
	:s3_bucket, 
	:plivo_auth_id, 
	:plivo_auth_token,
	:plivo_number
	].each do |req|
		raise StandardError.new("You must set #{req.to_s} in the ENV") unless Figaro.env.respond_to? req
	end