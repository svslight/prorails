require 'rails_helper'

feature 'User can add links to answer', %q{
 In order to provide additional info to my answer
 As an question's author
 I'd like to be able to add links
} do

  given(:user_author) { create(:user) }
  given(:question) { create(:question, author: user_author) }
  given(:gist_url) { 'https://gist.github.com/svslight/27070131e9bb343b0343770b13cd62de' }
  given(:google_url) { 'https://google.com' }

  background do
    sign_in(user_author)
    visit question_path(question)
  end

  scenario 'User adds multiple links when give an answer', js: true do
    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add Links'

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'My google'
      fill_in 'Url', with: google_url
    end
 
    click_on 'Create'

    within '.answers' do
      expect(page).to have_content 'Вопрос 1 Ответ 1 Ответ'
      expect(page).to have_link 'My google', href: google_url      
    end    
  end

  scenario 'User adds link with invalid URL when give an answer', js: true do
    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'Error'

    click_on 'Create'

    expect(page).not_to have_content 'Links url is not a valid URL'
  end 
end
