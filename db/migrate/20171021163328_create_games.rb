class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :state
      t.integer :white_player_user_id
      t.integer :black_player_user_id
      t.integer :winner_user_id
      t.integer :turn_user_id
      t.timestamps
    end
  end
end
