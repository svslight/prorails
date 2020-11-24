FactoryBot.define do
  factory :comment do
    user
    sequence(:body) { |n| "Comment#{n}" }

    trait :invalid do
      body { nil }
    end
  end
end
