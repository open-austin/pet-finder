require 'spec_helper'

describe Shelter do

	describe '#map_link' do 
	
		it "will return a google link based on the name" do
			Shelter.new(name: 'Austin Animal Center').map_link.should eq 'https://www.google.com/maps/preview?safe=off&q=Austin%20Animal%20Center'
		end
	
	end

	describe '#to_s' do 
	
		it "will return the name of the shelter" do
			Shelter.new(name: 'Austin Animal Center').to_s.should eq 'Austin Animal Center'
		end
	
	end

end
