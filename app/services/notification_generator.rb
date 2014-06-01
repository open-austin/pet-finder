class NotificationGenerator

	def self.generate_for(pet)
		notifications = Notification
			.maybe(:species, pet.species)
			.maybe(:gender, pet.gender)
			.maybe(:fixed, pet.fixed)
			.maybe(:color, pet.color)

		notifications.each do |notification|
			notification.send_notification
		end
	end

end