require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to leave a answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background  do
      sign_in(user)
      # sign_in(create(:user))

      visit question_path(question)

    end

    scenario 'post answer' do
      fill_in 'Body', with: 'answer text'
      click_on 'Reply'

      expect(page).to have_content 'Your answer successfully created.' 
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'answer text'
    end

    scenario 'post answer with errors' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end 

  end

  scenario 'Unauthenticated user tries to post answer'do
    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end