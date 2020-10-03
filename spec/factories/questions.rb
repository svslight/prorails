FactoryBot.define do
  factory :question do
    # title { "MyString" }
    # body { "MyText" }

    sequence(:title) { |n| "Title#{n}" }
    sequence(:body) { |n| "Body#{n}" }

    trait :invalid do
      title {nil}      
    end
  end
end
