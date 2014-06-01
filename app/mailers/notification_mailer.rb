class NotificationMailer < ActionMailer::Base
  default from: "petfinderatx@gmail.com"

  def welcome_email(user)
  	@user = user
  	mail(to: @user.email, subject: 'Welcome to the PetFinder Newsfeed!')
  end

  def notify_email(user, pet = nil)
    @user = user
    # @pet = pet
    mail(to: @user.email, subject: 'You Have a New PetFinder Match!')
  end
end
