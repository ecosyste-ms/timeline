class AddActorIndexToEvents < ActiveRecord::Migration[8.0]
  def change
    ActiveRecord::Base.connection.execute("SET statement_timeout TO 0;") # No timeout
    add_index :events, :actor
    ActiveRecord::Base.connection.execute("RESET statement_timeout;")
  end
end
