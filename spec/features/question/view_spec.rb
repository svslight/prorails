require 'rails_helper'

feature 'User can see a list of questions', %q(  
  I'd like to see the list of questions.
) do
  
  given(:author) { create(:user) }

  scenario 'User sees a list of questions' do
    questions = create_list(:question, 3, author: author)
    visit questions_path

    questions.each { |question| expect(page).to have_content(question.title) }
  end
end
