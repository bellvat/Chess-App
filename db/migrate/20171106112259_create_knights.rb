class CreateKnights < ActiveRecord::Migration[5.1]
  def change
    create_table :knights do |t|

      t.timestamps
    end
  end
end
