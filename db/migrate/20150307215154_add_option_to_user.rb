class AddOptionToUser < ActiveRecord::Migration
  def change
    add_column :users, :option, :string
  end
end
