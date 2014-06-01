require 'spec_helper'

describe Notification do

	describe '#contact' do 
	
		it "will be populated with the notification email and phone" do
			notification = described_class.new(email: 'test@email.com', phone: '123-456-7890')
			notification.contact.email.should eq 'test@email.com'
			notification.contact.phone.should eq '123-456-7890'
		end
	
	end
end
