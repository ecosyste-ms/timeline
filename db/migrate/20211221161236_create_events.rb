class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :actor
      t.string :event_type
      t.string :repository
      t.string :owner
      t.json :payload, default: "{}", null: false

      t.datetime "created_at", precision: 6, null: false

      # t.index ["actor"], name: "index_events_on_actor"
      # t.index ["created_at"], name: "index_events_on_created_at"
      # t.index ["owner"], name: "index_events_on_owner"
      # t.index ["event_type"], name: "index_events_on_event_type"
      # t.index ["repository"], name: "index_events_on_repository"
    end
  end
end
