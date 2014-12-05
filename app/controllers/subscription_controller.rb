class SubscriptionController < ApplicationController

	def confirm
		
	end

  def subscribe
    subscription = Subscription.new(subscription_params)
    NotificationMailer.welcome_email(subscription.contact).deliver if subscription.should_email?
    render json: { success: subscription.save }
  end

  def unsubscribe
    value = params[:email_or_phone]
    Subscription.where(email: value).destroy_all
    Subscription.where(phone: value).destroy_all
    render json: { success: true }
  end

  private

  def subscription_params
    params.require(:subscription).permit(:email, :phone, :species, :found_since, :gender)
  end
  
end
