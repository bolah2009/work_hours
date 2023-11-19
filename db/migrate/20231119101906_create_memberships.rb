class CreateMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :memberships do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :organization, null: false, foreign_key: true
      t.belongs_to :role, null: false, foreign_key: true

      t.index %i[role_id user_id], name: 'index_memberships_on_role_id_and_user_id'
      t.index %i[organization_id user_id], name: 'index_memberships_on_organization_id_and_user_id'

      t.timestamps
    end
  end
end
