require 'spec_helper'

describe SubscriptionController do

	describe "GET 'confirm'" do
		
		it "confirms the subscription on success" do
			Subscription.create email: 'test@email.com', confirmation_code: '1234'
			get :confirm, confirmation_code: '1234'
			Subscription.first.should be_confirmed
		end

		it "flashes a success message on success" do
			Subscription.create email: 'test@email.com', confirmation_code: '1234'
			get :confirm, confirmation_code: '1234'
			flash[:success].should eq 'Your alert is confirmed.'

		end
		
		it "flashes an error with a bad confirmation code" do
			Subscription.create email: 'test@email.com', confirmation_code: '1234'
			get :confirm, confirmation_code: 'badcode'
			Subscription.first.should_not be_confirmed
			flash[:danger].should eq 'We couldn\'t find that confirmation code.'
		end

	end

	describe "POST 'confirm'" do
		
		it "confirms the subscription on success" do
			Subscription.create email: 'test@email.com', confirmation_code: '1234'
			post :confirm, confirmation_code: '1234'
			Subscription.first.should be_confirmed
		end

		it "flashes a success message on success" do
			Subscription.create email: 'test@email.com', confirmation_code: '1234'
			post :confirm, confirmation_code: '1234'
			flash[:success].should eq 'Your alert is confirmed.'

		end
		
		it "flashes an error with a bad confirmation code" do
			Subscription.create email: 'test@email.com', confirmation_code: '1234'
			post :confirm, confirmation_code: 'badcode'
			Subscription.first.should_not be_confirmed
			flash[:danger].should eq 'We couldn\'t find that confirmation code.'
		end

	end

	describe "POST 'subscribe'" do

		let (:subscription_params) { { subscription: { email: 'test@email.com', species: 'cat', gender: 'male', found_since: Date.new(2014).to_s } } } 
			
		before do
			Sidekiq::Testing.inline!
		end

		it "creates a subscription" do
			post :subscribe, subscription_params
			Subscription.count.should eq 1
			Subscription.first.confirmation_code.should_not be_nil
		end

		it "redirects back to the results page" do
			response = post :subscribe, subscription_params 
			response.should redirect_to results_url(subscription_params)
			flash[:success].should eq 'We\'ve sent you a confirmation code to confirm your alerts. <a href="http://test.host/confirm">Click here</a> to confirm'
		end

		it "sends out a subscription email" do
			post :subscribe, subscription_params
			ActionMailer::Base.deliveries.count.should eq 1
		end

		it "sends out a subscription text" do
			SMS.should_receive(:send).with('1231231234', /Your PetAlerts subscription code is: /)
			post :subscribe, subscription: { phone: '1231231234' }
		end

		it "fails without email or phone" do
			subscription_params[:subscription].delete :email
			response = post :subscribe, subscription_params 
			response.should redirect_to results_url(subscription_params)
			flash[:danger].should eq 'Email or phone is required.'
		end

		it "will not send out notifications for existing pets" do
			Pet.create(species: 'cat', gender: 'male')
			post :subscribe, subscription_params
			ActionMailer::Base.deliveries.count. should eq 1
		end

	end

	describe "GET 'unsubscribe'" do 
	
		it "deletes the existing subscription by email" do
			Subscription.create(email: 'test@email.com', phone: '123-456-7890')
			get :unsubscribe, { email_or_phone: 'test@email.com' }
			Subscription.all.should be_empty
		end

		it "deletes the existing subscription by phone" do
			Subscription.create(email: 'test@email.com', phone: '123-456-7890')
			get :unsubscribe, { email_or_phone: '123-456-7890' }
			Subscription.all.should be_empty
		end

		it "will not delete non-matching subscriptions" do
			Subscription.create(email: 'test1@email.com', phone: '123-456-7890')
			Subscription.create(email: 'test2@email.com', phone: '123-456-7891')
			Subscription.create(email: 'test3@email.com', phone: '123-456-7892')
			get :unsubscribe, { email_or_phone: 'test@emaildifferent.com' }
			Subscription.count.should eq 3
			get :unsubscribe, { email_or_phone: '123-456-5432' }
			Subscription.count.should eq 3
		end
	
	end

	describe "POST 'unsubscribe'" do 
	
		it "deletes the existing subscription by email" do
			Subscription.create(email: 'test@email.com', phone: '123-456-7890')
			post :unsubscribe, { email_or_phone: 'test@email.com' }
			Subscription.all.should be_empty
		end

		it "deletes the existing subscription by phone" do
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
