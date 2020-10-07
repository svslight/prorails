require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user_author) { create(:user) }
  given!(:question) { create(:question, author: user_author) }
  given!(:answer) { create(:answer, question: question, author: user_author) }

  given!(:other_user) { create(:user) }
  given!(:other_answer) { create(:answer, question: question, author: other_user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user_author)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do 
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      within "#answer-#{other_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
