class ChangeNotificationsToSubscriptions < ActiveRecord::Migration
  def change
  	rename_table :notifications, :subscriptions
  end
end
