require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do
  
  given!(:user_author) { create(:user) }
  given!(:question) { create(:question, author: user_author) }

  given!(:other_user) { create(:user) }
  given!(:other_question) { create(:question, author: other_user) }
  
  scenario 'Unauthenticated can not edit question' do
    visit questions_path
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user_author)
      visit questions_path
    end

    scenario 'edits his question' do
      click_on 'Edit'
      fill_in 'Your question', with: 'edited question'      
      click_on 'Save'
      
      within "#question-#{question.id}" do
        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      click_on 'Edit'
      fill_in 'Your question', with: ''
      click_on 'Save'

      within "#question-#{question.id}" do
        expect(page).to have_content question.title
      end
      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      within "#question-#{other_question.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
