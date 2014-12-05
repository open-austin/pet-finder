describe NotificationSender do

	before do
		ActionMailer::Base.deliveries.clear
	end

	describe '::matching' do 

		before do
			Subscription.create(confirmed_at: Time.now, email: 'test1@email.com', species: 'dog', gender: 'male', color: "brown")
			Subscription.create(confirmed_at: Time.now, email: 'test2@email.com', species: 'dog', gender: 'female')
			Subscription.create(confirmed_at: Time.now, email: 'test3@email.com', species: 'cat', color: 'black')
		end

		it "will not send notifications for unconfirmed subscriptions" do
			Subscription.create(email: 'test4@email.com', species: 'cat', color: 'blue')
			pet = Pet.create(species: 'cat', color: 'blue')
			NotificationSender.matching(pet).send_all
			ActionMailer::Base.deliveries.should be_empty
		end

		it "sends notifications to searches that positively match" do
			pet = Pet.create(species: 'dog', gender: 'male', color: 'brown', shelter: Shelter.new)
			NotificationSender.matching(pet).send_all
			ActionMailer::Base.deliveries.count.should eq 1
		end

		it "sends notifications to searches that neutrally match" do
			pet = Pet.create(species: 'dog', gender: 'female', color: 'brown', shelter: Shelter.new)
			NotificationSender.matching(pet).send_all
			ActionMailer::Base.deliveries.count.should eq 1
		end

		it "will not send notifications to searches that negatively match" do
			pet = Pet.create(species: 'cat')
			NotificationSender.matching(pet).send_all
			ActionMailer::Base.deliveries.should be_empty
		end

	end

end