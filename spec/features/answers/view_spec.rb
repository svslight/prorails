require 'rails_helper'

feature 'User can view the question and answers to it', %q(
  I'd like to view the question and answers to it.
) do

  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }

  scenario 'User can view the question and its answers' do
    answers = create_list(:answer, 4, question: question, author: author)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each { |answer| expect(page).to have_content(answer.body) }
  end  
end
