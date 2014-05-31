require 'spec_helper'

describe Image do
  
	describe '::from_pet_id' do 
	
		it "will set the url" do
			Image.from_pet_id('A037822').url.should eq 'http://www.petharbor.com/get_image.asp?RES=Detail&ID=A037822&LOCATION=ASTIN'
		end
	
	end

	describe '#url' do 
	
		it "will return the path appended to the url base" do
			Image.new(path: '?var=test').url.should eq 'http://www.petharbor.com/get_image.asp?var=test'
		end
	
	end

	describe '#to_s' do 
	
		it "will return the url of the image" do
			Image.new(path: '?var=test').to_s.should eq 'http://www.petharbor.com/get_image.asp?var=test'
		end
	
	end
end
