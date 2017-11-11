class RemoveTypeFromPieces < ActiveRecord::Migration[5.1]
  def change
    remove_column :pieces, :type, :string
  end
end
