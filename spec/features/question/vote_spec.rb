require 'rails_helper'

feature 'User can vote for the question', %q(
  To vote for an interesting question
  As authenticated user
  I would like to be able to vote
) do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Unauthenticated user tries' do
    scenario 'vote an question' do
      visit question_path(question)

      within(".vote-question-block-#{question.id}") do
        find('.vote-up').click
      end

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'Not the author votes for the question', js: true do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'First vote up'
    scenario 'Re-vote up'
    scenario 'Cancel vote up'

    scenario 'First vote down'
    scenario 'Re-vote down'
    scenario 'Cancel vote down'
  end

  describe 'Author cannot vote for the question', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Vote up'
    scenario 'Vote down'
  end
end
