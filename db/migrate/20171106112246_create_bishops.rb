class CreateBishops < ActiveRecord::Migration[5.1]
  def change
    create_table :bishops do |t|

      t.timestamps
    end
  end
end
