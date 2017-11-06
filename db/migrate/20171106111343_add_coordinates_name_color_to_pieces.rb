class AddCoordinatesNameColorToPieces < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :white?, :boolean
    add_column :pieces, :x_coord, :integer
    add_column :pieces, :y_coord, :integer
    add_column :pieces, :game_id, :integer
    add_column :pieces, :user_id, :integer
    remove_column :pieces, :color
  end
end
