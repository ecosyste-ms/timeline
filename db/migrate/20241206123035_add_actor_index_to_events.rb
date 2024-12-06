class AddActorIndexToEvents < ActiveRecord::Migration[8.0]
  def change
    add_index :events, :actor
  end
end
