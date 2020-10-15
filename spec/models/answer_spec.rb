require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'best answer' do
    let(:user_author) { create(:user) }
    let(:question) { create(:question, author: user_author) }
    let(:answer) { create(:answer, question: question, author: user_author) }
  
    let(:other_user) { create(:user) }
    let(:other_answer) { create(:answer, question: question, author: user_author) }
  
    context 'mark best' do
      it 'mark best == true' do
        answer.mark_best
        expect(answer).to be_best
      end
  
      it 'mark best == false' do
        expect(other_answer).to_not be_best
      end
  
      it 'only one answer may be the best' do
        answer.mark_best
        expect(answer).to be_best
        expect(question.answers.where(best: true).count).to eq 1
      end    
    end
  end
end
