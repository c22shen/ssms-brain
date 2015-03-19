class AddVolumeToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :volume, :int
  end
end
