FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { generate(:password_valid) }
    email { Faker::Internet.unique.email }

    # make given password accessible for e.g. authentication logic
    before(:create) do |user|
      password_plain = user.password
      user.define_singleton_method(:password_plain, -> { password_plain })
    end
  end

  sequence(:password_valid) do |n|
    "SOme-pass#{n}"
  end
end
