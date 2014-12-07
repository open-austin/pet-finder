class ChangeFoundOnToDatetime < ActiveRecord::Migration
  def change
  	change_column :pets, :found_on, :datetime
  end
end
