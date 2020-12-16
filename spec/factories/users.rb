FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }

    # 他のユーザー
    trait :other_user do
      email { "other_user@example.com" }
    end
  end
end
