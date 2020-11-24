FactoryBot.define do
  factory :link do

    # sequence(:name) { |n| "URL #{n}" }
    # sequence(:url) { |n| "https://example.com/#{n}" }

    # name { 'Google' }
    # url { 'https://google.com' }

    name { 'Link' }
    url { 'https://example.com' }
  end

  factory :gist_link, class: Link do
    name { 'Gist' }
    url { 'https://gist.github.com/svslight/27070131e9bb343b0343770b13cd62de' }
  end
end
