require 'rails_helper'

feature 'User can delete links from answer', %q{
  As the author of the answer
  I would like to be able to remove links from the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, linkable: answer) }

  given(:other_user) { create(:user) }
  given!(:other_answer) { create(:answer, question: question, author: other_user) }
  given!(:gist_link) { create(:gist_link, linkable: other_answer) }

  scenario 'Unauthenticated user cannot delete link' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete Link'
  end

  describe 'Authenticated user tries', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'delete link from his answer' do
      expect(page).to have_link 'Google'
      click_on 'Delete Link'
      expect(page).not_to have_link 'Google'
    end

    scenario 'delete link from not his answer' do
      within(".link-#{gist_link.id}") do
        expect(page).not_to have_link 'Delete Link'
      end
    end
  end
end