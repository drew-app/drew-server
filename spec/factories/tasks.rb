FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Task Number #{n}"}
  end
end
