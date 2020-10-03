FactoryBot.define do
  factory :answer do
    # body { "MyText" }
    sequence(:body) { |n| "Answer#{n}" }

    trait :invalid do
      body { nil }
    end
  end
end
