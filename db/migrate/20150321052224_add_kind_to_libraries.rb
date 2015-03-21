class AddKindToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :kind, :string
  end
end
