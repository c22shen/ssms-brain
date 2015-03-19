class AddVolumeToSeats < ActiveRecord::Migration
  def change
    add_column :seats, :volume, :int
  end
end
