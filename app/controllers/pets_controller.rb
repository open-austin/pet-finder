class PetsController < ApplicationController
  
  # GET /pets/search
  def search
    @subscription = Subscription.new
  end

  # GET /pets/results
  def results
    @description = search_description

    @pets = Pet.where(species: subscription_params[:species]).sort_by(&:found_on).reverse
    @pets = @pets.maybe(:gender, subscription_params[:gender])
    @pets = @pets.where("found_on > ?", Date.strptime(subscription_params[:found_since],"%m/%d/%Y")) if subscription_params[:found_since].present?

    @subscription = Subscription.new(subscription_params)
  end

  # GET /pets/1
  def show
    @pet = Pet.find(params[:id])
  end

  # POST /pets/results/subscribe
  def subscribe
    subscription = Subscription.new(params[:subscription])
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
    params[:subscription]
  end

  def search_description
    gender, species, found_since = subscription_params[:gender], subscription_params[:species], subscription_params[:found_since]
    puts subscription_params.inspect
    desc = gender.present? ? "#{gender} " : ""
    desc += "#{species} lost"
    desc += " on #{Date.strptime(found_since, '%m/%d/%Y')}" if found_since.present?
  end

end
