require 'rails_helper'

feature 'User can delete his question', %q(
  As an author of the question
  I would like to be able to delete my question
) do

  given(:user_author) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user_author)
    end

    scenario 'can delete his question' do
      questions = create_list(:question, 4, author: user_author)
      visit question_path(questions.first)
  
      click_link 'Delete'
  
      expect(page).to have_content 'Your question was successfully deleted.'
      expect(page).to have_no_content questions.first.title
    end
  end
  
  scenario 'wants to delete another user question'
  scenario 'Unauthenticated user tries to delete a question'

end
