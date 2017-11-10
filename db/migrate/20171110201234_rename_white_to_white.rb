class RenameWhiteToWhite < ActiveRecord::Migration[5.1]
  def change
    rename_column :pieces, :white?, :white

  end
end
