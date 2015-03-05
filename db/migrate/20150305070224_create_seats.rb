class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :uid
      t.string :status
      t.float :x
      t.float :y
      t.timestamps
    end
  end
end
