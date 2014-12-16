class Notifier
	include Sidekiq::Worker

	sidekiq_options queue: 'notifier'

	def perform(pet_id)
		NotificationSender.matching(Pet.find(pet_id)).send_all
	end

end