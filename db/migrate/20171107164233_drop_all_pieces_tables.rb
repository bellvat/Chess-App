class DropAllPiecesTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :kings
    drop_table :queens
    drop_table :rooks
    drop_table :knights
    drop_table :bishops
    drop_table :pawns
  end
end
