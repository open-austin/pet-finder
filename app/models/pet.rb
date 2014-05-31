class Pet < ActiveRecord::Base
  belongs_to :shelter
  belongs_to :image
end
