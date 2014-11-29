require 'spec_helper'

describe PetPopulatorController, vcr: true do
	include AuthHelper

	describe "POST 'update'" do

		def pet_hash(options={})
			defaults = { image: 'http://www.petharbor.com/get_image.asp?RES=Detail&ID=A692581&LOCATION=ASTN', status: 'BOTH', species: 'cat', name: 'fluffy', pet_id: SecureRandom.uuid, gender: 'male', fixed: true, breed: 'tabby', found_on: Date.new(2014).to_s, scraped_at: Time.new.to_s, shelter_name: 'Austin Pet Shelter', color: 'brown' } 
			defaults.merge options
		end

		let (:pets_string) do
			{ 
				pets: {
					"0" => pet_hash(pet_id: '1234'), 
					"1" => pet_hash(name: 'duffy'), 
					"2" => pet_hash(species: 'dog'), 
					"3" => pet_hash(shelter_name: 'Test Shelter') 
				}
			}
		end

		it "will reject unauthenticated requests" do
			post :update, pets_string
			expect(response).to_not be_success
			Pet.count.should eq 0
		end

		context 'when authenticated properly' do

			before :each do
				AWS.stub!
				http_login 'username', 'password'
			end

			it "will succeed" do
				post :update, pets_string
				expect(response).to be_success
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

			it "will send out notifications for new pets" do
				# puts ActionMailer::Base.deliveries.count
				Subscription.create(email: 'test@email.com', species: 'dog')
				post :update, pets_string
				ActionMailer::Base.deliveries.count.should eq 1
			end

		end

	end

	describe "POST 'reconcile'" do

		before do
			Pet.create(pet_id: '1234')
			Pet.create(pet_id: '2345')
			Pet.create(pet_id: '3456')
		end

		it "will reject unauthenticated requests" do
			post :reconcile, { pet_ids: { '0' => '1234', '1' => '3456' } }
			expect(response).to_not be_success
			Pet.where(pet_id: '2345').first.should be_active
		end

		context 'when authenticated properly' do

			before :each do
				http_login 'username', 'password'
				post :reconcile, { pet_ids: { '0' => '1234', '1' => '3456' } }
			end

			it "will succeed" do
				expect(response).to be_success
			end

			it "will leave the sent ids active" do
				Pet.where(pet_id: [ '1234', '3456' ]).each {|pet| pet.should be_active }
			end
			
			it "will mark missing ids as inactive" do
				Pet.where(pet_id: '2345').first.should_not be_active
			end
			
		end

	end

end