class AddCreatedAtBrinIndex < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  
  def change
    add_index :events, :created_at, using: 'brin', algorithm: :concurrently
  end
end
