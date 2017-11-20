class AddKingCheckToPieces < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :king_check, :integer, :default => 0
  end
end
