require 'rails_helper'

feature 'User can add links to answer', %q{
 In order to provide additional info to my answer
 As an question's author
 I'd like to be able to add links
} do

  given(:user_author) { create(:user) }
  given(:question) { create(:question, author: user_author) }
  given(:url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/svslight/2961d14ca27abfbd66d86c1211d8dba9' }

  scenario 'User adds link when give an question', js: true do
    sign_in(user_author)

    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
 
    click_on 'Create'

    # проверяем что ссылки появились на странице в разделе с классом answers
    # within - добаляем чтобы отличать от ссылок на вопросы
    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end    
  end
end