class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.string :species
      t.string :name
      t.string :pet_id
      t.string :gender
      t.boolean :fixed
      t.string :breed
      t.date :found_on
      t.timestamp :scraped_at
      t.references :shelter, index: true
      t.references :image, index: true

      t.timestamps
    end
    add_index :pets, :species
    add_index :pets, :pet_id
    add_index :pets, :gender
    add_index :pets, :fixed
    add_index :pets, :breed
  end
end
