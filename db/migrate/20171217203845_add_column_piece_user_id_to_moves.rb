class AddColumnPieceUserIdToMoves < ActiveRecord::Migration[5.1]
  def change
    add_column :moves, :piece_user_id, :integer
  end
end
