require 'rails_helper'

feature 'Author can delete files attached to their question', %q{
  If he uploaded the wrong file or it has lost relevance
} do

  given(:user_author) { create(:user) }
  given(:question) { create(:question, author: user_author) }

  given(:other_user) { create(:user) }
  given(:other_question) { create(:question, author: other_user) }

  scenario 'Unauthenticated user cannot delete attached file' do
    visit questions_path
    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user_author)
    end
    
    scenario 'delete attached file from his question' do
      question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit questions_path

      click_on 'Edit'
      click_on 'Delete File'
      expect(page).not_to have_link 'spec_helper.rb'
    end

    scenario 'cannot delete attached file if not author' do
      other_question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
    
      visit questions_path
      expect(page).not_to have_link 'Save'
    end
  end
end