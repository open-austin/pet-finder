class NotificationMailer < ActionMailer::Base
  default from: "petfinderatx@gmail.com"

  def subscription_email(subscription)
  	@subscription = subscription
  	mail(to: subscription.email, subject: 'Confirm your alert with PetAlerts!')
  end

  def notification_email(subscription, pet)
    @pet = pet
    @subscription = subscription
    mail(to: subscription.email, subject: 'PetAlerts Match: Is this your pet?')
  end
end
