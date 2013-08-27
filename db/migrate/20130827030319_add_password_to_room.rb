class AddPasswordToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :password, :string
  end
end
