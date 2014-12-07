require 'spec_helper'

describe Subscription do

	describe 'validations' do
		
		it 'requires an email address or phone number to validate' do
			Subscription.create.errors.full_messages.first.should eq 'Email or phone is required.'
			Subscription.create(email: 'test@email.com').errors.should be_empty
			Subscription.create(phone: '555-555-5555').errors.should be_empty
		end

		it 'requires a valid email address' do
			Subscription.create(email: 'bademail').errors.full_messages.first.should eq 'Email is not an email address'
		end

		it 'requires a valid phone number' do
			Subscription.create(phone: 'badphone').errors.full_messages.first.should eq 'Phone is not a phone number'
			Subscription.create(phone: '123').errors.full_messages.first.should eq 'Phone is not a phone number'
			Subscription.create(phone: '1234567890').errors.should be_empty
			Subscription.create(phone: '123-456-7890').errors.should be_empty
			Subscription.create(phone: '(123)456-7890').errors.should be_empty
		end

	end

	describe '::maybe' do 
	
		before do
			@subscription = Subscription.create(email: 'test@email.com', species: 'dog', gender: '')
		end

		it "returns matching conditions" do
			Subscription.maybe(:species, 'dog').should include @subscription
		end

		it "returns nil conditions" do
			Subscription.maybe(:color, 'brown').should include @subscription
		end

		it "returns empty string conditions" do
			Subscription.maybe(:gender, 'male').should include @subscription
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
	
		it "returns whether the subscription should be emailed" do
			Subscription.new.should_email?.should be_false
			Subscription.new(email: 'test@email.com').should_email?.should be_true
		end
	
	end

	describe '#should_text?' do 
	
		it "returns whether the subscription should be emailed" do
			Subscription.new.should_text?.should be_false
			Subscription.new(phone: '123-456-7890').should_text?.should be_true
		end
	
	end

	describe '#as_params' do
		
		it "returns the non-blank values of a subscription that are used in result searches" do
			subscription = Subscription.new(species: 'dog', gender: 'male', email: 'test@email.com', phone: '123-456-7890', fixed: false, color: 'brown')
			subscription.as_params.should eq({ species: 'dog', gender: 'male', email: 'test@email.com', phone: '123-456-7890' })
		end

	end

	describe 'confirmation' do

		describe 'scopes' do

			before do
				@sub1 = Subscription.create email: 'test@email.com', confirmed_at: Time.now
				@sub2 = Subscription.create email: 'test@email.com'
				@sub3 = Subscription.create email: 'test@email.com', confirmed_at: Time.now
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
