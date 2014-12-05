require 'spec_helper'

describe Subscription do

	describe '::maybe' do 
	
		before do
			@subscription = Subscription.create(species: 'dog')
		end

		it "will return matching conditions" do
			Subscription.maybe(:species, 'dog').should include @subscription
		end

		it "will return nil conditions" do
			Subscription.maybe(:color, 'brown').should include @subscription
		end

		it "will not return non-matching conditions" do
			Subscription.maybe(:species, 'cat').should_not include @subscription
		end
	
	end

	describe '#contact' do 
	
		it "will be populated with the subscription email and phone" do
			subscription = described_class.new(email: 'test@email.com', phone: '123-456-7890')
			subscription.contact.email.should eq 'test@email.com'
			subscription.contact.phone.should eq '123-456-7890'
		end
	
	end

	describe '#should_email?' do 
	
		it "will return whether the subscription should be emailed" do
			Subscription.new.should_email?.should be_false
			Subscription.new(email: 'test@email.com').should_email?.should be_true
		end
	
	end

	describe '#should_text?' do 
	
		it "will return whether the subscription should be emailed" do
			Subscription.new.should_text?.should be_false
			Subscription.new(phone: '123-456-7890').should_text?.should be_true
		end
	
	end

	describe 'confirmation' do

		describe 'scopes' do

			before do
				@sub1 = Subscription.create(confirmed_at: Time.now)
				@sub2 = Subscription.create()
				@sub3 = Subscription.create(confirmed_at: Time.now)
			end

			it "returns confirmed subscriptions" do
				Subscription.confirmed.should =~ [@sub1, @sub3]
			end

			it "returns unconfirmed subscriptions" do
				Subscription.unconfirmed.should =~ [@sub2]
			end

		end

		it "is unconfirmed by default" do
			Subscription.new.should_not be_confirmed
		end
		
		it "can mark a subscription as confirmed" do
			subscription = Subscription.new
			subscription.confirm!
			subscription.confirmed_at.should be_within(1).of(Time.now)
			subscription.should be_confirmed
		end

	end
end
