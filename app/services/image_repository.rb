require 'net/http'
require 'securerandom'

class ImageRepository

	def self.store(image_url, suggestion="image")
		filename = "#{SecureRandom.uuid}--#{suggestion}.jpg"

		file = bucket.objects[filename] or raise "Cannot create key - #{filename}"
		file.write download_image(image_url), acl: :public_read or raise "Cannot write to file - #{filename}"
		
		file.public_url.to_s
	end

	private

	def self.download_image(image_url)
		Net::HTTP.get URI(image_url)
	end

	def self.s3
		AWS::S3.new
	end

	def self.bucket
		s3.buckets[Figaro.env.s3_bucket] or raise "Bucket not found - #{Figaro.env.s3_bucket}"
	end

end