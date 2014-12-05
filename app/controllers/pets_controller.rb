class PetsController < ApplicationController
  
  def search
    @subscription = Subscription.new
  end

  def results
    @description = search_description

    @pets = Pet.active.where(species: subscription_params[:species]).order(found_on: :desc)
    @pets = @pets.maybe(:gender, subscription_params[:gender])
    @pets = @pets.where("found_on > ?", Date.strptime(subscription_params[:found_since],"%m/%d/%Y")) if subscription_params[:found_since].present?

    @subscription = Subscription.new(subscription_params)
  end

  def show
    @pet = Pet.find(params[:id])
  end

  private

  def search_description
    gender, species, found_since = subscription_params[:gender], subscription_params[:species], subscription_params[:found_since]
    desc = gender.present? ? "#{gender} " : ""
    desc += "#{species} lost"
    desc += " on #{Date.strptime(found_since, '%m/%d/%Y')}" if found_since.present?
  end

end
