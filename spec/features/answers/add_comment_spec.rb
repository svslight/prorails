require 'rails_helper'

feature 'Add comment to answer', %q{
  As an authenticated user
  I want to be able comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user tries to create comment for answer' do
    visit question_path(question)

    within '.add-answer-comment' do
      expect(page).not_to have_content 'Add Comment'
    end
  end

  context 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for answer with valid attributes' do
      within '.add-answer-comment' do
        fill_in 'Comment', with: 'Comment'
        click_on 'Add comment'
        expect(page).to have_content 'Comment'
      end
    end
    scenario 'creates comment for answer with invalid attributes' do
      within '.add-answer-comment' do
        fill_in 'Comment', with: ''
        click_on 'Add comment'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end

end
