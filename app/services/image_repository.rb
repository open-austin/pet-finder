require 'net/http'
require 'securerandom'

class ImageRepository

	def self.store(image_url, suggestion="image")
		response = download_image image_url
		
		if is_valid_image? response
			image = FileHandler.safe_name "#{suggestion}.jpg"
			image.write response
		else
			image = FileHandler.new '_default/pet-avatar.png'
		end
		image.url
	end

	private

	def self.download_image(image_url)
		Net::HTTP.get URI(image_url)
	end

	def self.is_valid_image?(response)
		response.length > 1000
	end

	class FileHandler

		def initialize(filename)
			@file = file_from filename
		end

		def self.safe_name(filename)
			self.new "#{SecureRandom.uuid}--#{filename}"
		end

		def url
			@file.public_url.to_s
		end

		def write(content)
			@file.write content, acl: :public_read or raise "Cannot write to file - #{filename}"
		end

		private 

		def s3
			AWS::S3.new
		end

		def bucket
			s3.buckets[Figaro.env.s3_bucket] or raise "Bucket not found - #{Figaro.env.s3_bucket}"
		end

		def file_from(filename)
			bucket.objects[filename] or raise "Cannot create key - #{filename}"
		end

	end

end