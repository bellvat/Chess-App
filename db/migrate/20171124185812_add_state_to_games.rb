class AddStateToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :state, :string
  end
end
