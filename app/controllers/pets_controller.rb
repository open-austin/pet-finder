class PetsController < ApplicationController
  
  # GET /pets/search
  def search
    @subscription = Subscription.new
  end

  # GET /pets/results
  def results
    gender = params[:subscription][:gender]
    species = params[:subscription][:species]
    @found_since = params[:subscription][:found_since]
    @looking_for = "#{gender} #{species}"
    @subscription = Subscription.new
    @pets = Pet.where(species: species)
    @pets = @pets.where(gender: gender) if !gender.nil?
    @pets = @pets.where("found_on > ?", Date.strptime(@found_since,"%m/%d/%Y")) if !@found_since.nil?
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

end
