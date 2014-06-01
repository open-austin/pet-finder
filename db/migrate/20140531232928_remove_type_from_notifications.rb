class RemoveTypeFromNotifications < ActiveRecord::Migration
  def change
  	remove_column :notifications, :type
  end
end
