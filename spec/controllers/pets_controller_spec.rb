require 'spec_helper'

describe PetsController do

	describe "POST 'subscribe'" do

		let (:subscription_params) { { subscription: { email: 'test@email.com', species: 'cat', gender: 'male', found_since: Date.new(2014).to_s } } } 
			
		it "will create a subscription" do
			post :subscribe, subscription_params
			Subscription.count.should eq 1
		end

		it "will return a success message" do
			response = post :subscribe, subscription_params
			response.body['success'].should be_true
		end

		it "will send out a welcome email" do
			Pet.create(species: 'cat', gender: 'male')
			post :subscribe, subscription_params
			ActionMailer::Base.deliveries.count.should eq 1
		end

		it "will not send out notifications for existing pets" do
			Pet.create(species: 'cat', gender: 'male')
			post :subscribe, subscription_params
			puts ActionMailer::Base.deliveries
			ActionMailer::Base.deliveries.count. should eq 1
		end

	end

	describe "POST 'unsubscribe'" do 
	
		it "will delete the existing subscription by email" do
			Subscription.create(email: 'test@email.com', phone: '123-456-7890')
			post :unsubscribe, { email_or_phone: 'test@email.com' }
			Subscription.all.should be_empty
		end

		it "will delete the existing subscription by phone" do
			Subscription.create(email: 'test@email.com', phone: '123-456-7890')
			post :unsubscribe, { email_or_phone: '123-456-7890' }
			Subscription.all.should be_empty
		end

		it "will not delete non-matching subscriptions" do
			Subscription.create(email: 'test1@email.com', phone: '123-456-7890')
			Subscription.create(email: 'test2@email.com', phone: '123-456-7891')
			Subscription.create(email: 'test3@email.com', phone: '123-456-7892')
			post :unsubscribe, { email_or_phone: 'test@emaildifferent.com' }
			Subscription.count.should eq 3
			post :unsubscribe, { email_or_phone: '123-456-5432' }
			Subscription.count.should eq 3
		end
	
	end

end