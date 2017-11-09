class AddNameToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :name, :string
    add_index :games, :name 
  end
end
