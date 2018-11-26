FactoryBot.define do
  factory :task do
    user
    sequence(:title) { |n| "Task Number #{n}"}
    description ''
  end
end
