class AlterGamesAddUserIdColumn < ActiveRecord::Migration[5.1]

  def change
    add_column :games, :user_id, :integer
    add_index :games, :user_id
  end

end
