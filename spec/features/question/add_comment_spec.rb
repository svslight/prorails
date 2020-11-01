require 'rails_helper'

feature 'Add comment to question', %q{
  As an authenticated user
  I want to be able comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user tries to create comment for question' do
    visit question_path(question)

    within '.add-question-comment' do
      expect(page).not_to have_content 'Add Comment'
    end
  end

  context 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for question with valid attributes' do
      within '.add-question-comment' do
        fill_in 'Comment', with: 'Comment'
        click_on 'Add comment'
        expect(page).to have_content 'Comment'
      end
    end

    scenario 'creates comment for question with invalid attributes' do
      within '.add-question-comment' do
        fill_in 'Comment', with: ''
        click_on 'Add comment'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'multiple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.add-question-comment' do
          fill_in 'Comment', with: 'Question Comment'
          click_on 'Add comment'
          expect(page).to have_content 'Question Comment'
        end
      end

      Capybara.using_session('guest') do
        within '.add-question-comment' do
          expect(page).to have_content 'Question Comment'
        end
      end
    end
  end
end
