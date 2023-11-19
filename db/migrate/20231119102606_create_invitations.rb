class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.belongs_to :sender, null: false, foreign_key: { to_table: :users }
      t.belongs_to :recipient, null: false, foreign_key: { to_table: :users }
      t.belongs_to :organization, null: false, foreign_key: true
      t.belongs_to :role, null: false, foreign_key: true
      t.string :token, null: false

      t.timestamps
    end
    add_index :invitations, :token, unique: true
  end
end
