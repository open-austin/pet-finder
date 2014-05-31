class AddActiveToPets < ActiveRecord::Migration
  def change
    add_column :pets, :active, :boolean, default: true
  end
end
