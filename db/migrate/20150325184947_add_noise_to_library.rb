class AddNoiseToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :noise, :integer
  end
end
