class AddColorToPieces < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :color, :string
  end
end
