class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps
      t.string :email
      t.string :phone_number
    end

    add_index :users, :email
    add_index :users, :phone_number
  end
end
