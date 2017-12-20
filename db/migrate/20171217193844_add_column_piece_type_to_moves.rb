class AddColumnPieceTypeToMoves < ActiveRecord::Migration[5.1]
  def change
    add_column :moves, :piece_type, :string
  end
end
