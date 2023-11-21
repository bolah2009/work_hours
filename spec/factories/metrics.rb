FactoryBot.define do
  factory :metric do
    start_time { '09:01:02' }
    end_time { '18:10:29' }
    date { '2023-11-04' }
    user
    organization
  end
end
