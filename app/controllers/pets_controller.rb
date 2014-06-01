class PetsController < ApplicationController
  
  # GET /pets/search
  def search
    @subscription = Subscription.new
  end

  # GET /pets/results
  def results
    @gender = params[:gender]
    @species = params[:species]
    @found_since = params[:found_since]
    @looking_for = "#{@gender} #{@species}"
    @pets = Pet.where("species = ? AND gender = ? AND found_on > ?", @species, @gender, @found_since)
  end

  # GET /pets/1
  def show
    @pet = Pet.find(params[:id])
  end

  # POST /pets/results/subscribe
  def subscribe
    @notification = Subscription.new
    @gender = params[:gender]
    @species = params[:species]
    @found_since = params[:found_since]
    @looking_for = "#{@gender} #{@species}"
    @pets = Pet.where("species = ? AND gender = ? AND found_on > ?", @species, @gender, @found_since)
  end

end
