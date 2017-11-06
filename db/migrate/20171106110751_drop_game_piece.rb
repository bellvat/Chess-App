class DropGamePiece < ActiveRecord::Migration[5.1]
  def change
    drop_table :game_pieces
  end
end
