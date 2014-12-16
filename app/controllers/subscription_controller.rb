require 'securerandom'

class SubscriptionController < ApplicationController

  def subscribe
    subscription = Subscription.new(subscription_params)
    subscription.confirmation_code = SecureRandom.urlsafe_base64 4
    subscription.phone = subscription.phone.gsub /[^\d]+/, ""
    if subscription.save
      NotificationMailer.delay.subscription_email(subscription) if subscription.should_email?
      SMS.send subscription.phone, "Your PetAlerts subscription code is: #{subscription.confirmation_code}" if subscription.should_text?
      
      confirm_link = ActionController::Base.helpers.link_to('Click here', confirm_url)
      flash[:success] = "We've sent you a confirmation code to confirm your alerts. #{confirm_link} to confirm"
    else
      flash[:danger] = subscription.errors.full_messages.first
    end
    redirect_to results_url(subscription: subscription.as_params)
  end

	def confirm
    return render 'confirm' unless params[:confirmation_code].present?

		subscription = Subscription.find_by params.permit(:confirmation_code)
	  if subscription.present?
      subscription.confirm!
      subscription.save
      flash[:success] = 'Your alert is confirmed.'
    else
      flash[:danger] = 'We couldn\'t find that confirmation code.'
    end

    url = params[:redirect].present? ? params[:redirect] : root_url
    redirect_to url
  end

  def unsubscribe
    return render 'unsubscribe' unless params[:email_or_phone].present?

    value = params[:email_or_phone]
    Subscription.where(email: value).destroy_all
    Subscription.where(phone: value).destroy_all

    flash[:success] = 'Your alert is removed.'
    redirect_to root_url
  end

  private

  def subscription_params
    params.require(:subscription).permit(:email, :phone, :species, :found_since, :gender)
  end
  
end
