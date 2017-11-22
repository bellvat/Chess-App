class AddLoserUserIdToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :loser_user_id, :integer
  end
end
