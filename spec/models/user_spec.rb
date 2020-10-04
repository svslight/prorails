require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:author_questions) }
  it { should have_many(:author_answers) }

  let(:author) { create(:user) }
  let(:author_questions) { create(:question, author: author) }
  let(:author_answers) { create(:answer, question: author_questions, author: author) }

  let(:other_author) { create(:user) }
  let(:other_question) { create(:question, author: other_author) }
  let(:other_answer) { create(:answer, question: other_question, author: other_author) }

  it 'User is author of question' do
    expect(author).to be_author(author_questions)
  end

  it 'User is not author of question' do
    expect(author).not_to be_author(other_question)
  end

  it 'User is author of answer' do
    expect(author).to be_author(author_answers)
  end

  it 'User is not author of answer' do
    expect(author).not_to be_author(other_answer)
  end

  # it { should validate_presence_of :email }
  # it { should validate_presence_of :password }

  # describe 'author?' do
  #   let(:author) { create(:user) }

  #   it 'returns true if the user is the author of the question' do
  #     question = create(:question, author: author)
  #     expect(author).to be_author(question)
  #   end

  #   it 'returns false if the user is not the author of the question' do
  #     question = create(:question)
  #     expect(author).not_to be_author(question)
  #   end
  # end
end
