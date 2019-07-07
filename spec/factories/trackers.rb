FactoryBot.define do
  factory :tracker do
    user
    title { "Go to bed on time" }

    trait :with_tracker_records do
      tracker_records { build_list(:tracker_record, 3) }
    end
  end
end
