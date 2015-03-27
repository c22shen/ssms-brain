class AddSizeToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :size, :integer
  end
end
