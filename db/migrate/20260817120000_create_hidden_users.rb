class CreateHiddenUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :hidden_users do |t|
      t.string :login, null: false

      t.timestamps
    end

    add_index :hidden_users, :login, unique: true
  end
end
