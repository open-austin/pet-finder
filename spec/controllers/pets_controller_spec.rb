require 'spec_helper'

describe PetsController do

	describe "POST 'subscribe'" do

		let (:subscription_params) { { email: 'test@email.com', species: 'cat', gender: 'male', found_since: Date.new(2014).to_s } } 
			
		it "will create a subscription" do
			post :subscribe, subscription_params
			Subscription.count.should eq 1
		end

		it "will return a success message" do
			response = post :subscribe, subscription_params
			response.body['success'].should be_true
		end

		it "will not send out notifications for existing pets" do
			Pet.create(species: 'cat', gender: 'male')
			post :subscribe, subscription_params
			ActionMailer::Base.deliveries.should be_empty
		end

	end

end