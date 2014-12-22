require 'spec_helper'

describe Pet do
	it_behaves_like 'a time_scopable'

	let (:concernable) { Pet }
	let (:pet) { subject }

	describe '::active' do 

		before do
			@pet1 = Pet.create active: true
			@pet2 = Pet.create active: false
			@pet3 = Pet.create active: true
		end
	
		it "returns active pets" do
			Pet.active.should =~ [ @pet1, @pet3 ]
		end
	
	end

	describe '::imageless' do
		
		before do
			@pet1 = Pet.create image: Pet::DEFAULT_IMG
			@pet2 = Pet.create image: 'actual-image'
			@pet3 = Pet.create image: Pet::DEFAULT_IMG
		end

		it "returns pets with the default image" do
			Pet.imageless.should =~ [ @pet1, @pet3 ]
		end

	end

	describe '::type' do
		
		before do
			@pet1 = Pet.create species: 'cat'
			@pet2 = Pet.create species: 'cat'
			@pet3 = Pet.create species: 'dog'
		end
	
		it "loads pets by the specified value" do
			Pet.type('cat').should =~ [ @pet1, @pet2 ]
			Pet.type('dog').should =~ [ @pet3 ]
		end

	end

	describe '::maybe' do 

		before do
			@pet1 = Pet.create species: 'cat'
			@pet2 = Pet.create species: 'cat'
			@pet3 = Pet.create species: 'dog'
		end
	
		it "loads pets by the specified value" do
			Pet.maybe(:species, 'cat').should =~ [ @pet1, @pet2 ]
		end

		it "ignores nil values" do
			Pet.maybe(:species, nil).should =~ [ @pet1, @pet2, @pet3 ]
		end
	
	end

	describe '::found_since' do

		before do
			@pet1 = Pet.create found_on: 2.days.ago
			@pet2 = Pet.create found_on: 1.day.ago
			@pet3 = Pet.create found_on: Time.now
		end

		it "loads pets by date" do
			Pet.found_since(3.days.ago).should =~ [ @pet1, @pet2, @pet3 ]
			Pet.found_since(1.days.ago).should =~ [ @pet2, @pet3 ]
			Pet.found_since(Time.now).should =~ [ @pet3 ]
		end

		it "ignores nil values" do
			Pet.found_since(nil).should =~ [ @pet1, @pet2, @pet3 ]
		end

	end

	describe '::for_subscription' do
		
		it "applies all the relevant details of the subscription" do
			@pet1 = Pet.create species: 'cat', gender: 'male', found_on: 2.days.ago
			@pet2 = Pet.create species: 'dog', gender: 'female', found_on: 1.day.ago
			@pet3 = Pet.create species: 'cat', gender: 'female', found_on: 1.day.ago

			Pet.for_subscription(Subscription.new(species: 'cat')).should =~ [ @pet1, @pet3 ]
			Pet.for_subscription(Subscription.new(species: 'cat', gender: 'female')).should =~ [ @pet3 ]
			Pet.for_subscription(Subscription.new(species: 'dog', found_since: Time.now.utc)).should =~ []
		end

	end

	describe '::from_hash' do 
	
		it "adds a persisted shelter" do
			pet = Pet.from_hash(shelter_name: 'Test Shelter')
			Shelter.where(name: 'Test Shelter').should be_exists
			pet.shelter.should eq Shelter.where(name: 'Test Shelter').first
		end

		it "will not add a shelter if no shelter name is given" do
			pet = Pet.from_hash(pet_id: '1234')
			pet.shelter.should be_nil
		end
	
	end

	describe '#mark_inactive!' do 
	
		it "marks the pet as inactive" do
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
