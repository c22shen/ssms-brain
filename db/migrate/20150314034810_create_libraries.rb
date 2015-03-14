class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string :name
      t.float :lat
      t.float :lon
      t.string :floors
      t.string :school
      t.text :description

      t.timestamps
    end
  end
end
