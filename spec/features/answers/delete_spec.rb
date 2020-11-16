require 'rails_helper'

feature 'User can delete his answer', %q(
  As an author of the answer
  I would like to be able to delete my answer
) do

  given(:user_author) { create(:user) }
  given(:question) { create(:question, author: user_author) }
  given!(:answer) { create(:answer, question: question, author: user_author) }

  given(:other_user) { create(:user) }
  given!(:other_answer) { create(:answer, question: question, author: other_user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user_author)
      visit question_path(question)
    end

    scenario 'can delete his answer' do
      expect(page).to have_content answer.body

      click_on 'Delete'

      expect(page).not_to have_content answer.body
    end

    # scenario 'wants to delete another user answer' do
    #   within("#answer-#{other_answer.id}") do
    #     expect(page).to have_content other_answer.body
    #     expect(page).to_not have_link 'Delete'
    #   end
    # end
  end

  describe 'Unauthenticated user' do
    scenario 'trying to delete answer' do
      visit question_path(question)
      within("#answer-#{answer.id}") do
        expect(page).to have_content answer.body
        expect(page).to_not have_link 'Delete'
      end
    end
  end

end
