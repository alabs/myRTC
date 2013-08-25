class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :subscribers, :default => 0

      t.timestamps
    end
  end
end
