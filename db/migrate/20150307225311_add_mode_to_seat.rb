class AddModeToSeat < ActiveRecord::Migration
  def change
    add_column :seats, :mode, :string
  end
end
