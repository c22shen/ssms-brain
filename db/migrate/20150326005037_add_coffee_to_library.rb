class AddCoffeeToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :coffee, :boolean
  end
end
