class AddPropertiesToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :email, :string
    add_column :notifications, :phone, :string
    add_column :notifications, :species, :string
    add_index :notifications, :species
    add_column :notifications, :gender, :string
    add_index :notifications, :gender
    add_column :notifications, :fixed, :boolean
    add_index :notifications, :fixed
    add_column :notifications, :found_since, :date
    add_column :notifications, :color, :string
    add_index :notifications, :color
  end
end
