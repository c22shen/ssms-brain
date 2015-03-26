class AddTableToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :table, :boolean
  end
end
