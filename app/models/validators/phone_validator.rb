module Validators
	class PhoneValidator < ActiveModel::EachValidator
	  def validate_each(record, attribute, value)
	    unless value =~ /\A\(?\d{3}[\)-]?\d{3}-?\d{4}\z/i
	      record.errors[attribute] << (options[:message] || "is not a phone number")
	    end
	  end
	end
end