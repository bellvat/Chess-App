class AddTypeToPiece < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :type, :string
  end
end
