class AddZToSeats < ActiveRecord::Migration
  def change
    add_column :seats, :z, :float
  end
end
