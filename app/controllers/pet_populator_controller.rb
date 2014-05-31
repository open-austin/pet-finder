class PetPopulatorController < ApplicationController
  before_filter :verified_request?

  def update
  	pets = pets_params[:pets].map {|pet_hash| Pet.from_hash(pet_hash)}
  	pets_to_save = pets.select {|pet| Pet.where(pet_id: pet.pet_id).empty?}
  	pets_to_save.each {|pet| pet.save}
  	render nothing: true
  end

  def reconcile
  	pets_to_remove = Pet.where.not(pet_id: params[:pet_ids])
  	pets_to_remove.each do |pet| 
  		pet.mark_inactive!
  		pet.save
  	end
  	render nothing: true
  end

  private

  def pets_params
    params.permit(pets: [ :species, :name, :pet_id, :gender, :fixed, :breed, :found_on, :scraped_at, :shelter_name, :color ])
  end

end
