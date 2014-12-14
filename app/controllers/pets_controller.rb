class PetsController < ApplicationController
  
  def search
    @subscription = Subscription.new
  end

  def results
    @subscription = Subscription.new(subscription_params)
    @pets = Pet.active.reverse_chrono.for_subscription(@subscription).page(params[:page]).per_page(20)
  end

  def show
    @pet = Pet.find(params[:id])
  end

  private

  def subscription_params
    params.require(:subscription).permit(:email, :phone, :species, :found_since, :gender)
  end

end
