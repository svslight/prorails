require 'rails_helper'

feature 'User can edit links to answer',  %q{
  As the author of the attached links to the answer
  I would like to be able to fix them
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Author can edit link from his answer', js: true do
    sign_in user
    visit question_path(question)
    click_on 'Edit'

    within("#answer_nested_form_#{answer.id}") do
      fill_in 'Link name', with: 'Google'
    end

    click_on 'Save'

    expect(page).to have_content 'Google'
  end
end
