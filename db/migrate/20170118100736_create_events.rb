class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name,           null: false
      t.integer :organizer_id,  null: false, index: true
      t.timestamp :time,        null: false, index: true
      t.string :place,          null: false
      t.text :description

      t.timestamps
    end
  end
end
