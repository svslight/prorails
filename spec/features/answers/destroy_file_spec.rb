require 'rails_helper'

feature 'Author can delete files from his answer', %q{
  If he uploaded the wrong file or it has lost relevance
} do

  given(:user_author) { create(:user) }
  given(:question) { create(:question, author: user_author) }
  given(:answer) { create(:answer, question: question, author: user_author) }

  given(:other_user) { create(:user) }
  given(:other_answer) { create(:answer, question: question, author: other_user) }

  scenario 'Unauthenticated user cannot delete attached file' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user_author)
    end

    scenario 'delete attached file from his answer' do
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)

      within "#answer-#{answer.id}" do
        click_on 'Edit'
        click_on 'Delete File'
        expect(page).not_to have_link 'spec_helper.rb'
      end
    end

    scenario 'cannot delete attached file if not author' do
      other_answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
