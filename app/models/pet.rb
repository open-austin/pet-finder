class Pet < ActiveRecord::Base
  belongs_to :shelter
  belongs_to :image

  attr_accessible :species, :name, :pet_id, :gender, :fixed, :breed, :found_on, :scraped_at, :color
  attr_accessible :shelter, :image

  def self.from_hash(hash)
  	unless hash[:shelter_name].blank?
	  	shelter = Shelter.find_or_create_by(name: hash.delete(:shelter_name))  
	  	hash.merge! shelter: shelter
	  end

  	image = Image.from_pet_id(hash[:pet_id])
  	hash.merge! image: image unless image.blank?

  	Pet.new(hash)
  end

  def mark_inactive!
    self.active = false
  end

  def active?
    active
  end
end
