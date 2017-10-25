class RemoveStateFromGame < ActiveRecord::Migration[5.1]
  def change
    remove_column :games, :state, :string
  end
end
