class CreateQueens < ActiveRecord::Migration[5.1]
  def change
    create_table :queens do |t|

      t.timestamps
    end
  end
end
