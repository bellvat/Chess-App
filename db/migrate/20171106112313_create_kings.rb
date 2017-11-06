class CreateKings < ActiveRecord::Migration[5.1]
  def change
    create_table :kings do |t|

      t.timestamps
    end
  end
end
