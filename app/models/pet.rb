class Pet < ActiveRecord::Base
  belongs_to :shelter
  belongs_to :image

  def self.from_hash(hash)
  	unless hash[:shelter_name].blank?
	  	shelter = Shelter.find_or_create_by(name: hash.delete(:shelter_name))  
	  	hash.merge! shelter: shelter
	  end

  	image = Image.from_pet_id(hash[:id])
  	hash.merge! image: image unless image.blank?

  	Pet.new(hash)
  end
end
