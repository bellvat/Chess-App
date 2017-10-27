class CreateGamePieces < ActiveRecord::Migration[5.1]
  def change
    create_table :game_pieces do |t|
      t.integer :game_id
      t.integer :piece_id
      t.boolean :white?
      t.integer :x_coord
      t.integer :y_coord
      t.timestamps
    end
  end
end
