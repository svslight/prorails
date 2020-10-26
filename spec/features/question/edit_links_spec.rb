require 'rails_helper'

feature 'User can edit links to question', %q{
  As the author of the attached links to the question
  I would like to be able to fix them
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Author can edit link from his question', js: true do
    sign_in user
    visit questions_path
    click_on 'Edit'

    fill_in 'Link name', with: 'My google'
    fill_in 'Url', with: link

    click_on 'Add Links'

    within("#question_nested_form_#{question.id}") do
      fill_in 'Link name', with: 'Google'    
    end

    click_on 'Save'

    visit question_path(question)
    expect(page).to have_content 'Google'
  end
end
