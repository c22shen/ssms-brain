class AddLibraryidToSeat < ActiveRecord::Migration
  def change
    add_column :seats, :library_id, :int
  end
end
