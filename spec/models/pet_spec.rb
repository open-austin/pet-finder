require 'spec_helper'

describe Pet do

	let (:pet) { subject }

	describe '::active' do 

		before do
			@pet1 = Pet.create(active: true)
			@pet2 = Pet.create(active: false)
			@pet3 = Pet.create(active: true)
		end
	
		it "will return active pets" do
			Pet.active.should =~ [ @pet1, @pet3 ]
		end
	
	end

	describe '::maybe' do 

		before do
			@pet1 = Pet.create(species: 'cat')
			@pet2 = Pet.create(species: 'cat')
			@pet3 = Pet.create(species: 'dog')
		end
	
		it "will load pets by the specified value" do
			Pet.maybe(:species, 'cat').should =~ [ @pet1, @pet2 ]
		end

		it "will ignore nil values" do
			Pet.maybe(:species, nil).should =~ [ @pet1, @pet2, @pet3 ]
		end
	
	end

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
