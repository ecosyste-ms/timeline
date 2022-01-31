class AddIndexOnRepository < ActiveRecord::Migration[7.0]
  def change
    add_index :events, :repository
  end
end
