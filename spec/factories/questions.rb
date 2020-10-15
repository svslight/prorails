FactoryBot.define do
  factory :question do

    sequence(:title) { |n| "Title#{n}" }
    sequence(:body) { |n| "Question Body#{n}" }

    trait :invalid do
      title {nil}      
    end

    trait :with_files do
      before :create do |question|
        question.files.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
        question.files.attach fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")
      end
    end
  end
end
