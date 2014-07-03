class Image < ActiveRecord::Base

	BASE_URL   = 'http://www.petharbor.com/get_image.asp'
	RESOLUTION = 'Detail'
	LOCATION   = 'ASTN'

	def self.from_pet_id(id)
		Image.new(path: "?RES=#{RESOLUTION}&ID=#{id}&LOCATION=#{LOCATION}")
	end

	def url
		"#{BASE_URL}#{path}"
	end

	def to_s
		url
	end
end