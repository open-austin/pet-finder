require 'securerandom'

class PetPopulatorController < ApplicationController
  http_basic_authenticate_with name: Figaro.env.http_username, password: Figaro.env.http_password
  skip_before_action :verify_authenticity_token

  def update
  	pets_params.select {|pet_hash| Pet.where(pet_id: pet_hash[:pet_id]).empty?}.each do |pet_hash| 
      pet_hash[:image] = ImageRepository.store pet_hash.delete(:image), pet_hash[:pet_id]
      
      pet = Pet.from_hash(pet_hash)
      pet.save
      Notifier.perform_async(pet.id)
    end
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

  def pets_without_images
    render json: Pet.active.imageless.map {|pet| {id: pet.id, remote_id: pet.pet_id}}
  end

  def reconcile_image
    pet = Pet.find(params[:id])
    unless pet.has_image?
      pet.image = ImageRepository.store params[:image], pet.pet_id
      if pet.has_image?
        pet.save
        Notifier.perform_async(pet.id)
      end
    end
    render nothing: true
  end

  private

  def pets_params
    params[:pets].map(&:last).map {|pet_hash| pet_hash.except :status}
  end

  def id_params
    params[:pet_ids].map(&:last)
  end

end