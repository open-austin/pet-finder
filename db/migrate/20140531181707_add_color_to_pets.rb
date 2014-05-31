class AddColorToPets < ActiveRecord::Migration
  def change
    add_column :pets, :color, :string
    add_index :pets, :color
  end
end
