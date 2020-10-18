FactoryBot.define do
  factory :link do
    name { 'Google' }
    url { 'https://google.com' }
  end

  factory :gist_link, class: Link do
    name { 'Gist' }
    url { 'https://gist.github.com/svslight/27070131e9bb343b0343770b13cd62de' }
  end
end
