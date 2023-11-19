class Metric < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :date, presence: true, uniqueness: { scope: %i[user_id organization_id] }
  validates :end_time, comparison: { greater_than: :start_time }

  def self.user_aggregated_metrics(...)
    joins(:user)
      .where(...)
      .group('users.name', 'users.id')
      .select(
        'users.name AS user_name',
        'users.id AS user_id',
        'AVG(metrics.start_time)::time AS average_start_time',
        'AVG(metrics.end_time)::time AS average_end_time',
        'AVG(metrics.duration) AS average_duration',
        'SUM(metrics.duration) AS total_duration'
      )
      .order('user_name')
  end

  def self.user_metrics(...)
    joins(:user)
      .where(...)
      .select(
        'users.name AS user_name',
        'users.id AS user_id',
        'metrics.start_time',
        'metrics.end_time',
        'metrics.duration',
        'metrics.date'
      )
      .order('metrics.date DESC')
      .group_by(&:date)
  end
end
