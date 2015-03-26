class AddPlugToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :plug, :boolean
  end
end
