require 'rails_helper'

feature 'The author can choose the best answer', %q{
  As the author of the question
  I would like to choose the best answer.
} do
  
  given!(:user_author) { create(:user) }
  given!(:question) { create(:question, author: user_author) }
  given!(:answer) { create(:answer, question: question, author: user_author) }

  given!(:other_user) { create(:user) }

  scenario 'Unauthenticated user cannot choose the best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Best answer'
  end

  describe 'Authenticated user', js: true do
    scenario 'can choose the best answer if user owner of the question' do
      sign_in(user_author)
      visit question_path(question)
      
      within "#answer-#{answer.id}" do
        expect(page).not_to have_content 'Best answer!'
        click_on 'Best answer'
        expect(page).to have_content 'Best answer!'
      end
    end

    scenario 'cannot choose the best answer if user not owner of the question' do
      sign_in(other_user)
      visit question_path(question)
      expect(page).to_not have_link 'Best answer'
    end
  end

end
