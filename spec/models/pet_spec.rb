require 'spec_helper'

describe Pet do

	describe '::from_hash' do 
	
		it "will add a persisted shelter" do
			pet = Pet.from_hash(shelter_name: 'Test Shelter')
			Shelter.where(name: 'Test Shelter').should be_exists
			pet.shelter.should eq Shelter.where(name: 'Test Shelter').first
		end

		it "will not add a shelter if no shelter name is given" do
			pet = Pet.from_hash(id: '1234')
			pet.shelter.should be_nil
		end

		it "will generate an image" do
			pet = Pet.from_hash(id: "1234")
			pet.image.url.should eq 'http://www.petharbor.com/get_image.asp?RES=Detail&ID=1234&LOCATION=ASTIN'
		end
	
	end

end
