FactoryBot.define do
  factory :question do
    # title { "MyString" }
    # body { "MyText" }

    sequence(:title) { |n| "Title#{n}" }
    sequence(:body) { |n| "Question Body#{n}" }

    trait :invalid do
      title {nil}      
    end
  end
end
