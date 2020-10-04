require 'rails_helper'

feature 'User can delete his question', %q(
  As an author of the question
  I would like to be able to delete my question
) do

  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }

  given(:other_user) { create(:user) }
  given!(:other_question) { create(:question, author: other_user) }

  describe 'Authenticated user' do
    background do
      sign_in(author)
    end

    scenario 'can delete his question' do
      expect(page).to have_content question.title
  
      click_on  'Delete'
  
      expect(page).to have_content 'Your question was successfully deleted.'
      expect(page).not_to have_content question.title
    end

    scenario 'wants to delete another user question' do
      within("#question_#{other_question.id}") do
        expect(page).to have_content other_question.title
        expect(page).to_not have_link 'Delete'
      end    
    end
  end
  
  describe 'Unauthenticated user' do
    scenario 'trying to delete question' do
      visit questions_path
      within("#question_#{question.id}") do
        expect(page).to have_content question.title
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
