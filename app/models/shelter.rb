class Shelter < ActiveRecord::Base
	def map_link
		"https://www.google.com/maps/preview?safe=off&q=#{ERB::Util.url_encode name}"
	end

	def to_s
		name
	end
end
