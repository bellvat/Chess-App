class AddCapturedToPieces < ActiveRecord::Migration[5.1]
  def change
    add_column :pieces, :captured, :boolean, null: false, default: false
  end
end
