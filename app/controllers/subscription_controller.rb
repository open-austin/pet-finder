require 'securerandom'

class SubscriptionController < ApplicationController

	def confirm
		subscription = Subscription.find_by params.permit(:confirmation_code)
	  if subscription.present?
      subscription.confirm!
      subscription.save
      flash[:success] = 'You\'re alert is confirmed.'
      redirect_to root_url
    else
      flash[:danger] = 'There was an error with your confirmation code.'
      redirect_to root_url
    end
  end

  def subscribe
    subscription = Subscription.new(subscription_params)
    subscription.confirmation_code = SecureRandom.urlsafe_base64 8
    NotificationMailer.subscription_email(subscription).deliver if subscription.should_email?
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
