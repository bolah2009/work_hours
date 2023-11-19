class CreateMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :metrics do |t|
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.date :date, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :organization, null: false, foreign_key: true

      t.virtual :duration, type: :interval, as: 'end_time - start_time',
                           stored: true
      t.timestamps
    end
    add_index :metrics, :date
    add_index :metrics, %i[user_id organization_id date], unique: true, name: 'idx_user_organization_date_uniq'
  end
end
