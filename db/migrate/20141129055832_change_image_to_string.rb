class ChangeImageToString < ActiveRecord::Migration
  def change
  	remove_column :pets, :image_id
  	add_column :pets, :image, :string

  	drop_table :images
  end
end
