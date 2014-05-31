require 'spec_helper'

describe PetPopulatorController do

	describe "POST 'update'" do

		def pet_hash(options={})
			defaults = { species: 'cat', name: 'fluffy', pet_id: SecureRandom.uuid, gender: 'male', fixed: true, breed: 'tabby', found_on: Date.new(2014).to_s, scraped_at: Time.new.to_s, shelter_name: 'Austin Pet Shelter', color: 'brown' } 
			defaults.merge options
		end

		let (:pets_string) do
			{ 
				pets: [ 
					pet_hash(pet_id: '1234'), 
					pet_hash(name: 'duffy'), 
					pet_hash(species: 'dog'), 
					pet_hash(shelter_name: 'Test Shelter') 
				]
			}
		end

		it "will add non-existent animals to the database" do
			post :update, pets_string
			Pet.count.should eq 4
		end

		it "will not duplicate pet ids" do
			Pet.create(pet_id: '1234')
			post :update, pets_string
			Pet.count.should eq 4
		end

	end

	describe "POST 'reconcile'" do

		before do
			Pet.create(pet_id: '1234')
			Pet.create(pet_id: '2345')
			Pet.create(pet_id: '3456')
			post :reconcile, { pet_ids: [ '1234', '3456' ] }
		end

		it "will leave the sent ids active" do
			Pet.where(pet_id: [ '1234', '3456' ]).each {|pet| pet.should be_active }
		end
		
		it "will mark missing ids as inactive" do
			Pet.where(pet_id: '2345').first.should_not be_active
		end

	end

end