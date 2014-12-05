class AddConfirmedAtToSubscription < ActiveRecord::Migration
  def change
  	change_table :subscriptions do |t|
  		t.string :confirmation_code
  		t.datetime :confirmed_at
  	end
  end
end
