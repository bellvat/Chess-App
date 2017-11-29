class CreateMoves < ActiveRecord::Migration[5.1]
  def change
    create_table :moves do |t|
      t.integer :x_coord
      t.integer :y_coord
      t.integer :x_end
      t.integer :y_end
      t.integer :move_count
      t.boolean :captured 
      t.integer :game_id
      t.integer :piece_id

      t.timestamps
    end
  end
end
