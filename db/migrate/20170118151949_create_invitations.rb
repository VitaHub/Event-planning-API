class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.integer :user_id,   null: false, index: true
      t.integer :event_id,  null: false, index: true

      t.timestamps
    end

    add_index :invitations, [:user_id, :event_id], unique: true
  end
end
