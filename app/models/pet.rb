class Pet < ActiveRecord::Base
  belongs_to :shelter
  belongs_to :image

  def self.from_hash(hash)
  	shelter = Shelter.find_or_create_by(name: hash.delete(:shelter_name))
  	image 	
  end
end
