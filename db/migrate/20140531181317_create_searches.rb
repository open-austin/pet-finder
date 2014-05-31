class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.timestamps
      t.string :species
      t.string :gender
      t.boolean :fixed
      t.string :color
      t.string :breed
      t.date :found_on
    end
  end
end
