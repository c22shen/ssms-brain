class AddAddressToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :address, :string
  end
end
