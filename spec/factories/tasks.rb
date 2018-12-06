FactoryBot.define do
  factory :task do
    user
    sequence(:title) { |n| "Task Number #{n}"}
    description ''

    trait :with_tags do
      tags { build_list(:tag, 3, user: user) }
    end
  end
end
