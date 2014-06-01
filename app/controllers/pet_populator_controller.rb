class PetPopulatorController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update
  	pets = pets_params.map {|pet_hash| Pet.from_hash(pet_hash)}
  	pets_to_save = pets.select {|pet| Pet.where(pet_id: pet.pet_id).empty?}
  	pets_to_save.each {|pet| pet.save}
  	render nothing: true
  end

  def reconcile
  	pets_to_remove = Pet.where.not(pet_id: id_params)
  	pets_to_remove.each do |pet| 
  		pet.mark_inactive!
  		pet.save
  	end
  	render nothing: true
  end

  private

  def pets_params
    pets_hashes = []
    params[:pets].each do |pet|
      pets_hashes.push pet[1]
    end
    pets_hashes
  end

  def id_params
    ids = []
    params[:pet_ids].each do |id|
      ids.push id[1]
    end
    ids
  end

end