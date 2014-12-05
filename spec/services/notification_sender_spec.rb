describe NotificationSender do

	before do
		ActionMailer::Base.deliveries.clear
	end

	describe '::matching' do 

		before do
			@not1 = Subscription.create(confirmed_at: Time.now, email: 'test1@email.com', species: 'dog', gender: 'male', color: "brown")
			@not2 = Subscription.create(confirmed_at: Time.now, email: 'test2@email.com', species: 'dog', gender: 'female', fixed: true)
			@not3 = Subscription.create(confirmed_at: Time.now, email: 'test3@email.com', species: 'cat', fixed: false, color: 'black')
		end

		it "will send notifications to searches that positively match" do
			pet = Pet.create(species: 'dog', gender: 'male', fixed: true, color: 'brown', shelter: Shelter.new)
			NotificationSender.matching(pet).send_all
			ActionMailer::Base.deliveries.count.should eq 1
		end

		it "will send notifications to searches that neutrally match" do
			pet = Pet.create(species: 'dog', gender: 'female', fixed: true, color: 'brown', shelter: Shelter.new)
			NotificationSender.matching(pet).send_all
			ActionMailer::Base.deliveries.count.should eq 1
		end

		it "will not send notifications to searches that negatively match" do
			pet = Pet.create(species: 'cat', fixed: true)
			NotificationSender.matching(pet).send_all
			ActionMailer::Base.deliveries.should be_empty
		end

	end

end