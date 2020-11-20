FactoryBot.define do
  factory :answer do
    association :author, factory: :user
    
    sequence(:body) { |n| "Answer#{n}" }

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      before :create do |answer|
        answer.files.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
        answer.files.attach fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")
      end
    end
  end
end
