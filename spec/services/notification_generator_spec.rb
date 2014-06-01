describe NotificationGenerator do

	before do
		ActionMailer::Base.deliveries.clear
	end

	describe '::generate_for' do 

		before do
			@not1 = Notification.create(email: 'test1@email.com', species: 'dog', gender: 'male', color: "brown")
			@not2 = Notification.create(email: 'test2@email.com', species: 'dog', gender: 'female', fixed: true)
			@not3 = Notification.create(email: 'test3@email.com', species: 'cat', fixed: false, color: 'black')
		end

		it "will send notifications to searches that positively match" do
			pet = Pet.new(species: 'dog', gender: 'male', fixed: true, color: 'brown')
			NotificationGenerator.generate_for(pet)
			ActionMailer::Base.deliveries.count.should eq 1
		end

		it "will send notifications to searches that neutrally match" do
			pet = Pet.new(species: 'dog', gender: 'female', fixed: true, color: 'brown')
			NotificationGenerator.generate_for(pet)
			ActionMailer::Base.deliveries.count.should eq 1
		end

		it "will not send notifications to searches that negatively match" do
			pet = Pet.new(species: 'cat', fixed: true)
			NotificationGenerator.generate_for(pet)
			ActionMailer::Base.deliveries.should be_empty
		end

	end

end