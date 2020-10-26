FactoryBot.define do
  factory :reward do
    name { 'Reward' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/images/reward.jpg'), 'image/jpeg') }
  end
end
