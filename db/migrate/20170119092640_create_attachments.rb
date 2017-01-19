class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.references :user,   foreign_key: true,  index: true
      t.references :event,  foreign_key: true,  index: true
      t.string :file,       null: false

      t.timestamps
    end
  end
end
