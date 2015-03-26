class AddWifiToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :wifi, :boolean
  end
end
