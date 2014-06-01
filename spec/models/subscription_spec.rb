require 'spec_helper'

describe Subscription do

	describe '::maybe' do 
	
		before do
			@notification = Subscription.create(species: 'dog')
		end

		it "will return matching conditions" do
			Subscription.maybe(:species, 'dog').should include @notification
		end

		it "will return nil conditions" do
			Subscription.maybe(:color, 'brown').should include @notification
		end

		it "will not return non-matching conditions" do
			Subscription.maybe(:species, 'cat').should_not include @notification
		end
	
	end

	describe '#contact' do 
	
		it "will be populated with the notification email and phone" do
			notification = described_class.new(email: 'test@email.com', phone: '123-456-7890')
			notification.contact.email.should eq 'test@email.com'
			notification.contact.phone.should eq '123-456-7890'
		end
	
	end

	describe '#should_email?' do 
	
		it "will return whether the notification should be emailed" do
			Subscription.new.should_email?.should be_false
			Subscription.new(email: 'test@email.com').should_email?.should be_true
		end
	
	end

	describe '#should_text?' do 
	
		it "will return whether the notification should be emailed" do
			Subscription.new.should_text?.should be_false
			Subscription.new(phone: '123-456-7890').should_text?.should be_true
		end
	
	end
end
