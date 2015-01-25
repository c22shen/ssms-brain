class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :uid
      t.string :status

      t.timestamps
    end
  end
end
