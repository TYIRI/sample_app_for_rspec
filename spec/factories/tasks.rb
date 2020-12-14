FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Test Task #{n}" }
    content { "aaa" }
    status { 0 }
    deadline { 1.week.from_now }
    association :user
  end
end
