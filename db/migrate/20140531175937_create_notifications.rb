class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.timestamps
      t.string :type
      t.references :user, index: true
      t.references :search, index: true
    end

    add_index :notifications, :type
  end
end
