require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to leave a answer
} do

  given(:user_author) { create(:user) }
  given(:question) { create(:question, author: user_author) }

  describe 'Authenticated user', js: true do
    background  do
      sign_in(user_author)
      visit question_path(question)
    end

    scenario 'creates answer' do
      fill_in 'Your answer', with: 'My answer'
      click_on 'Create'

      # expect(page).to have_content 'Your answer successfully created.' 
      # expect(page).to have_content 'My answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
        expect(page).to have_content 'My answer'
      end
    end

    scenario 'creates answer with errors' do
      # sign_in(user_author)
      visit question_path(question)
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to post answer' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
