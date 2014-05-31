class AddActiveToPets < ActiveRecord::Migration
  def change
    add_column :pets, :active, :boolean, default: 1
  end
end
