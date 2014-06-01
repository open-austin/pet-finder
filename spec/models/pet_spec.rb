require 'spec_helper'

describe Pet do

	let (:pet) { subject }

	describe '::from_hash' do 
	
		it "will add a persisted shelter" do
			pet = Pet.from_hash(shelter_name: 'Test Shelter')
			Shelter.where(name: 'Test Shelter').should be_exists
			pet.shelter.should eq Shelter.where(name: 'Test Shelter').first
		end

		it "will not add a shelter if no shelter name is given" do
			pet = Pet.from_hash(pet_id: '1234')
			pet.shelter.should be_nil
		end

		it "will generate an image" do
			pet = Pet.from_hash(pet_id: "1234")
			pet.image.url.should eq 'http://www.petharbor.com/get_image.asp?RES=Detail&ID=1234&LOCATION=ASTN'
		end
	
	end

	describe '#mark_inactive!' do 
	
		it "will mark the pet as inactive" do
			pet.mark_inactive!
			pet.should_not be_active
		end
	
	end

	describe '#active?' do 
	
		it "defaults to true" do
			pet.should be_active
		end
	
	end
end
